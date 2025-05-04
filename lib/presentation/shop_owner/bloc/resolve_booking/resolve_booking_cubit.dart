import 'package:bloc/bloc.dart';
import 'package:tracio_fe/data/shop/models/waiting_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/cancel_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/complete_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/confirm_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/process_booking.dart';

import '../../../../service_locator.dart';
import 'resolve_booking_state.dart'; // Import the new state class

class ResolveBookingShopCubit extends Cubit<ResolveBookingShopState> {
  ResolveBookingShopCubit() : super(ResolveShopBookingInitial());
  DateTime? bookedDate;
  String? shopNote;
  String? adjPrice;
  String? price;
  String? reason;
  void updatebookedDate(DateTime newBookedDate) {
    bookedDate = newBookedDate;
    emit(UpdateParamsWaitingBooking(
        bookedDate: bookedDate,
        shopNote: shopNote,
        price: price,
        reason: reason));
  }

  void updateShopNote(String note) {
    shopNote = note;
    emit(UpdateParamsWaitingBooking(
        bookedDate: bookedDate,
        shopNote: shopNote,
        price: price,
        reason: reason));
  }

  void updatePrice(String newPrice, String newReason) {
    price = newPrice;
    adjPrice = newReason;
    emit(UpdateParamsWaitingBooking(
        adjPrice: adjPrice,
        bookedDate: bookedDate,
        shopNote: shopNote,
        price: price,
        reason: reason));
  }

  void resetState() {
    emit(ResolveShopBookingInitial());
  }

  void processBooking(int bookingId) async {
    var result = await sl<ProcessBookingUseCase>().call(bookingId);
    result.fold((error) {
      emit(ResolveBookingFailure(messgae: error.message));
    }, (data) {
      emit(ConfirmBookingSuccess());
    });
  }

  void cancelBooking(int bookingId) async {
    var result = await sl<CancelBookingUseCase>().call(bookingId);
    result.fold((error) {
      emit(ResolveBookingFailure(messgae: error.message));
    }, (data) {
      emit(ConfirmBookingSuccess());
    });
  }

  void completeBooking(int bookingId) async {
    var result = await sl<CompleteBookingUseCase>().call(bookingId);
    result.fold((error) {
      emit(ResolveBookingFailure(messgae: error.message));
    }, (data) {
      emit(ConfirmBookingSuccess());
    });
  }

  void resolvePendingBooking(String userNote, int bookingId) async {
    if (bookedDate == null) {
      print('⚠️ Booked date is null!');
    }

    var result = await sl<ConfirmBookingUseCase>().call(ConfirmBookingModel(
        adjustPriceReason: adjPrice,
        bookedDate: bookedDate,
        userNote: userNote,
        shopNote: shopNote,
        reason: reason,
        price: price,
        bookingId: bookingId));
    result.fold((error) {
      emit(WaitingBookingFailure());
    }, (data) {
      emit(ConfirmBookingSuccess());
    });
  }
  // void clearSelection() {
  //   emit(ResolveBookingShopState.initial());
  // }
}
