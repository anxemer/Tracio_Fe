// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tracio_fe/domain/shop/entities/response/booking_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/pagination_booking_data_entity.dart';

abstract class GetBookingState extends Equatable {
  final List<BookingEntity> bookingList;
  final List<BookingEntity> overlapBookingList;
  final PaginationBookingDataEntity pagination;

  const GetBookingState(
    this.bookingList,
    this.overlapBookingList,
    this.pagination,
  );
}

class GetBookingInitial extends GetBookingState {
  const GetBookingInitial(
      super.bookingList, super.overlapBookingList, super.pagination);

  @override
  List<Object?> get props => [];
}

class GetBookingLoading extends GetBookingState {
  const GetBookingLoading(
      super.bookingList, super.overlapBookingList, super.pagination);

  @override
  List<Object?> get props => [];
}

class GetBookingLoaded extends GetBookingState {
  const GetBookingLoaded(
    super.bookingList,
    super.overlapBookingList,
    super.pagination,
  );

  @override
  List<Object?> get props => bookingList;
}

class GetBookingFailure extends GetBookingState {
  const GetBookingFailure(
    super.bookingList,
    super.overlapBookingList,
    super.pagination,
    this.message,
  );
  final String message;
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
