import 'package:bloc/bloc.dart';
import 'package:tracio_fe/domain/shop/usecase/waiting_booking.dart';

import '../../../../service_locator.dart';
import 'resolve_booking_state.dart'; // Import the new state class

class ResolveBookingShopCubit extends Cubit<ResolveBookingShopState> {
  ResolveBookingShopCubit() : super(ResolveShopBookingInitial());
  DateTime? bookedDate;
  DateTime? estimatedEndDate;
  String? shopNote;

  void updatebookedDate(DateTime newBookedDate, int duration) {
    bookedDate = newBookedDate;
    estimatedEndDate = newBookedDate.add(Duration(minutes: duration));
    emit(UpdateParamsWaitingBooking(
        bookedDate: bookedDate,
        estimatedEndDate: estimatedEndDate,
        shopNote: shopNote));
  }

  void updateestimatedEndDate(DateTime endDate) {
    estimatedEndDate = endDate;
    emit(UpdateParamsWaitingBooking(
        bookedDate: bookedDate,
        estimatedEndDate: estimatedEndDate,
        shopNote: shopNote));
  }

  void updateShopNote(String note) {
    shopNote = note;
    emit(UpdateParamsWaitingBooking(
        bookedDate: bookedDate,
        estimatedEndDate: estimatedEndDate,
        shopNote: shopNote));
  }

  void resetState() {
    emit(ResolveShopBookingInitial());
  }

  void resolvePendingBooking(params) async {
    var result = await sl<WaitingBookingUseCase>().call(params);
    result.fold((error) {
      emit(WaitingBookingFailure());
    }, (data) {
      emit(WaitingBookingSuccess());
    });
  }
  // void clearSelection() {
  //   emit(ResolveBookingShopState.initial());
  // }
}
