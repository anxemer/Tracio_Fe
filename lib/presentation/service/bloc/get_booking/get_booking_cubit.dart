import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/domain/shop/entities/response/pagination_booking_data_entity.dart';
import 'package:tracio_fe/domain/shop/usecase/get_booking.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_state.dart';
import 'package:tracio_fe/service_locator.dart';

class GetBookingCubit extends Cubit<GetBookingState> {
  GetBookingCubit()
      : super(GetBookingInitial([], [], PaginationBookingDataEntity()));

  void getBooking(params) async {
    try {
      emit(GetBookingLoading([], [], PaginationBookingDataEntity()));
      var result = await sl<GetBookingUseCase>().call(params);
      result.fold((error) {
        emit(GetBookingFailure(
            [], [], PaginationBookingDataEntity(), error.message));
      }, (data) {
        emit(GetBookingLoaded(
            data.booking, data.bookingOverlap, data.pagination));
      });
    } on ExceptionFailure catch (e) {
      emit(GetBookingFailure([], [], PaginationBookingDataEntity(), e.message));
    }
  }
  void markBookingAsResolved(String bookingId) {
  if (state is GetBookingLoaded) {
    final currentState = state as GetBookingLoaded;
    final newResolvedMap = Map<String, bool>.from(currentState.resolvedMap);
    newResolvedMap[bookingId] = true;

    emit(currentState.copyWith(resolvedMap: newResolvedMap));
  }
}

}
