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

  MatchRequestCubit(this.matchingHub) : super(MatchRequestInitial()) {
    matchingHub.onRequestUpdate.listen(_onNewRequest);
  }

  void _onNewRequest(UserMatchingModel model) {
    if (_matchQueue.any((e) => e.otherUserId == model.otherUserId)) return;
    _matchQueue.add(model);
    if (_current == null) _showNext();
  }

  void _showNext() {
    if (_matchQueue.isEmpty) return;
    _current = _matchQueue.removeFirst();
    emit(MatchRequestVisible(_current!));

    _autoDismissTimer?.cancel();
    _autoDismissTimer = Timer(Duration(seconds: 10), () => dismiss(false));
  }

  void dismiss(bool accepted) {
    if (_current != null) {
      matchingHub.approveMatch(
        ApproveMatchModel(
          userId: _current!.userId,
          routeId: _current!.routeId,
          otherUserId: _current!.otherUserId,
          otherRouteId: _current!.otherRouteId,
          status: accepted ? "Accepted" : "Rejected",
        ),
      );
    }
    _current = null;
    emit(MatchRequestHidden());
    _showNext();
  }

  @override
  Future<void> close() {
    _autoDismissTimer?.cancel();
    return super.close();
  }
}
