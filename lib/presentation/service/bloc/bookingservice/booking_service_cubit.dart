import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/domain/shop/usecase/booking_service.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/booking_service_state.dart';

import '../../../../service_locator.dart';

class BookingServiceCubit extends Cubit<BookingServiceState> {
  BookingServiceCubit() : super(BookingServiceInitital());

  void bookingServie(params) async {
    try {
      emit(BookingServiceLoading());
      var response = await sl<BookingServiceUseCase>().call(params);
      response.fold((error) {
        emit(BookingServiceFailure(message: error.message));
      }, (data) {
        emit(BookingServiceSuccess(isSuccess: data));
      });
    } on ExceptionFailure catch (e) {
      emit(BookingServiceFailure(message: e.message));
    }
  }
}
