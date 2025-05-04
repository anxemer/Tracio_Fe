import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'resolve_overlap_service_state.dart';

enum OverlapActionStatus {
  confirmed,
  rescheduled,
  cancelled,
}

class ResolveOverlapServiceCubit extends Cubit<Map<int, OverlapActionStatus>> {
  ResolveOverlapServiceCubit() : super({});

  void markAction(int bookingId, OverlapActionStatus status) {
    final updatedMap = Map<int, OverlapActionStatus>.from(state);
    updatedMap[bookingId] = status;
    emit(updatedMap);
  }

  void clearAll() {
    emit({});
  }
}
