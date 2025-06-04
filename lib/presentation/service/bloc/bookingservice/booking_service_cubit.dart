import 'package:Tracio/domain/shop/usecase/reschedule_booking.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/shop/entities/response/cart_item_entity.dart';
import 'package:Tracio/domain/shop/usecase/booking_service.dart';
import 'package:Tracio/presentation/service/bloc/bookingservice/booking_service_state.dart';

import '../../../../common/helper/schedule_model.dart';
import '../../../../data/shop/models/reschedule_booking_model.dart';
import '../../../../service_locator.dart';

class BookingServiceCubit extends Cubit<BookingServiceState> {
  BookingServiceCubit() : super(BookingServiceInitital());
  List<CartItemEntity> selectedServices = [];
  List<int> reschedule = [];
  Map<String, String> serviceNotes = {};
  List<ScheduleModel>? schedules;
  void bookingServie(params) async {
    try {
      emit(BookingServiceLoading());
      var response = await sl<BookingServiceUseCase>().call(params);
      response.fold((error) {
        emit(BookingServiceFailure(message: error.message, failure: error));
      }, (data) {
        emit(BookingServiceSuccess(isSuccess: data));
      });
    } on ExceptionFailure catch (e) {
      emit(BookingServiceFailure(message: e.message, failure: e));
    }
  }

  void rescheduleService(params) async {
    try {
      emit(BookingServiceLoading());
      var response = await sl<RescheduleBookingUseCase>().call(
          RescheduleBookingModel(
              bookingIds: reschedule, userScheduleCreateDtos: params));
      response.fold((error) {
        emit(BookingServiceFailure(message: error.message, failure: error));
      }, (data) {
        emit(BookingServiceSuccess(isSuccess: data));
      });
    } on ExceptionFailure catch (e) {
      emit(BookingServiceFailure(message: e.message, failure: e));
    }
  }

  // void rescheduleBooking(params) async {
  //   try {
  //     var response = await sl<RescheduleBookingUseCase>().call(params);
  //     response.fold((error) {
  //       emit(BookingServiceFailure(message: error.message));
  //     }, (data) {
  //       emit(BookingServiceSuccess(isSuccess: data));
  //     });
  //   } on ExceptionFailure catch (e) {
  //     emit(BookingServiceFailure(message: e.message));
  //   }
  // }

  void addService(CartItemEntity service) {
    selectedServices.add(service);
    serviceNotes.putIfAbsent(service.itemId.toString(), () => "");
    emit(BookingServiceUpdated(
      cartItems: selectedServices,
      serviceNotes: serviceNotes,
      schedules: schedules,
    ));
  }

  void removeService(CartItemEntity service) {
    selectedServices.remove(service);
    serviceNotes.remove(service.itemId.toString());
    emit(BookingServiceUpdated(
      cartItems: selectedServices,
      serviceNotes: serviceNotes,
      schedules: schedules,
    ));
  }

  void updateNote(String serviceId, String note) {
    serviceNotes[serviceId] = note;
    emit(BookingServiceUpdated(
      cartItems: selectedServices,
      serviceNotes: serviceNotes,
      schedules: schedules,
    ));
  }

  void updateSchedules(List<ScheduleModel> newSchedules) {
    schedules = newSchedules;
    emit(BookingServiceUpdated(
      cartItems: selectedServices,
      serviceNotes: serviceNotes,
      schedules: schedules,
    ));
  }

  void removeSchedules(ScheduleModel removeSchedules) {
    schedules!.remove(removeSchedules);
    emit(BookingServiceUpdated(
      cartItems: selectedServices,
      serviceNotes: serviceNotes,
      schedules: schedules,
    ));
  }

  void addRescheduleBooking(int rescheduleId) {
    reschedule.add(rescheduleId);
    emit(RescheduleBookingUpdate(bookingId: reschedule, schedules: schedules));
  }

  void removeRescheduleBooking(int rescheduleId) {
    reschedule.remove(rescheduleId);
    emit(RescheduleBookingUpdate(bookingId: reschedule, schedules: schedules));
  }

  void clearBookingItem() {
    if (schedules != null) {
      schedules!.clear();
    }
    selectedServices.clear();
    serviceNotes.clear();
    reschedule.clear();
  }
}
