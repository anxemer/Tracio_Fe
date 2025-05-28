import 'dart:async';
import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/services/signalR/implement/matching_hub_service.dart';
import 'package:Tracio/data/map/models/matched_user.dart';

part 'match_request_state.dart';

class MatchRequestCubit extends Cubit<MatchRequestState> {
  final MatchingHubService matchingHub;
  final Queue<UserMatchingModel> _matchQueue = Queue();
  UserMatchingModel? _current;
  Timer? _autoDismissTimer;
  static const int _maxQueueSize = 5;
  static const int _autoDismissSeconds = 30;

  MatchRequestCubit(this.matchingHub) : super(MatchRequestInitial()) {
    matchingHub.onRequestUpdate.listen(_onNewRequest);
  }

  void _onNewRequest(UserMatchingModel model) {
    if (_matchQueue.any((e) => e.otherUserId == model.otherUserId)) return;

    // Limit queue size
    if (_matchQueue.length >= _maxQueueSize) {
      _matchQueue.removeLast(); // Remove oldest request
    }

    _matchQueue.add(model);
    if (_current == null) _showNext();
  }

  void _showNext() {
    if (_matchQueue.isEmpty) {
      emit(MatchRequestHidden());
      return;
    }

    _current = _matchQueue.removeFirst();
    emit(MatchRequestVisible(_current!, _autoDismissSeconds));

    _autoDismissTimer?.cancel();
    _autoDismissTimer = Timer(Duration(seconds: _autoDismissSeconds), () {
      if (_current != null) {
        dismiss(false);
      }
    });
  }

  Future<void> dismiss(bool accepted) async {
    if (_current == null) return;

    try {
      emit(MatchRequestLoading(_current!, accepted));

      await matchingHub.approveMatch(
        ApproveMatchModel(
          userId: _current!.userId,
          routeId: _current!.routeId,
          otherUserId: _current!.otherUserId,
          otherRouteId: _current!.otherRouteId,
          status: accepted ? "Accepted" : "Rejected",
        ),
      );

      _current = null;
      emit(MatchRequestHidden());
      _showNext();
    } catch (e) {
      emit(MatchRequestError(
        "Failed to ${accepted ? 'accept' : 'reject'} match request: ${e.toString()}",
        _current,
      ));

      // Retry after 3 seconds
      await Future.delayed(Duration(seconds: 3));
      if (_current != null) {
        emit(MatchRequestVisible(_current!, _autoDismissSeconds));
      }
    }
  }

  @override
  Future<void> close() {
    _autoDismissTimer?.cancel();
    _matchQueue.clear();
    return super.close();
  }
}
