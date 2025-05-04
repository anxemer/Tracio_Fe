import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracio_fe/domain/shop/usecase/reschedule_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/confirm_booking.dart';
import 'package:tracio_fe/service_locator.dart';

part 'reschedule_booking_state.dart';

class RescheduleBookingCubit extends Cubit<ResolveBookingState> {
  RescheduleBookingCubit() : super(RescheduleBookingInitial());

  void rescheduleBooking(params) async {
    var result = await sl<RescheduleBookingUseCase>().call(params);
    result.fold((error) {
      emit(RescheduleBookingFailure(message: error.message));
    }, (data) {
      emit(RescheduleBookingSuccess(isSuccess: data));
    });
  }

  void confirmBooking(params) async {
    var result = await sl<ConfirmBookingUseCase>().call(params);
    result.fold((error) {
      emit(RescheduleBookingFailure(message: error.message));
    }, (data) {
      emit(RescheduleBookingSuccess(isSuccess: data));
    });
  }
}
