import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/shop/entities/response/pagination_booking_data_entity.dart';
import 'package:Tracio/domain/shop/usecase/get_booking.dart';
import 'package:Tracio/presentation/service/bloc/get_booking/get_booking_state.dart';
import 'package:Tracio/service_locator.dart';

class GetBookingCubit extends Cubit<GetBookingState> {
  GetBookingCubit()
      : super(GetBookingInitial([], [], PaginationBookingDataEntity()));

  void getBooking(params) async {
    try {
      emit(GetBookingLoading([], [], PaginationBookingDataEntity()));
      var result = await sl<GetBookingUseCase>().call(params);
      result.fold((error) {
        emit(GetBookingFailure(
            [], [], PaginationBookingDataEntity(), error.message, error));
      }, (data) {
        emit(GetBookingLoaded(
            data.booking, data.bookingOverlap, data.pagination));
      });
    } on AuthenticationFailure catch (e) {
      emit(GetBookingFailure(
          [], [], PaginationBookingDataEntity(), e.message, e));
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
