// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tracio_fe/domain/shop/entities/response/cart_item_entity.dart';
import 'package:tracio_fe/presentation/service/widget/add_schedule.dart';

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
  BookingServiceFailure({
    required this.message,
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
