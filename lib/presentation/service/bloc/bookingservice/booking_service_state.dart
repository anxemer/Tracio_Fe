// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/shop/entities/response/cart_item_entity.dart';

import '../../../../common/helper/schedule_model.dart';

abstract class BookingServiceState {}

class BookingServiceInitital extends BookingServiceState {}

class BookingServiceLoading extends BookingServiceState {}

class BookingServiceSuccess extends BookingServiceState {
  final bool isSuccess;
  BookingServiceSuccess({
    required this.isSuccess,
  });
}

class BookingServiceFailure extends BookingServiceState {
  final String message;
  final Failure failure;
  BookingServiceFailure({
    required this.message,
    required this.failure,
  });
}

class BookingServiceUpdated extends BookingServiceState {
  final Map<String, String>? serviceNotes;
  final List<CartItemEntity>? cartItems;
  final List<ScheduleModel>? schedules;
  BookingServiceUpdated({
    this.serviceNotes,
    this.cartItems,
    this.schedules,
  });
}

class RescheduleBookingUpdate extends BookingServiceState {
  final List<int>? bookingId;
  final List<ScheduleModel>? schedules;
  RescheduleBookingUpdate({
    this.bookingId,
    this.schedules,
  });
}
