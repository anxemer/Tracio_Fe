import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/shop/usecase/get_booking.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_state.dart';
import 'package:tracio_fe/service_locator.dart';

class GetBookingCubit extends Cubit<GetBookingState> {
  GetBookingCubit() : super(GetBookingInitial(bookingList: []));

  void getBookingPending() async {
    try {
      emit(GetBookingLoading(bookingList: []));
      var result = await sl<GetBookingUseCase>().call(NoParams());
      result.fold((error) {
        emit(GetBookingFailure(message: error.message, bookingList: []));
      }, (data) {
        emit(GetBookingLoaded(bookingList: data));
      });
    } on ExceptionFailure catch (e) {
      emit(GetBookingFailure(message: e.message, bookingList: []));
    }
  }
}
