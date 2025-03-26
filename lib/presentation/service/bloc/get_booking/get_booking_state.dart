// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tracio_fe/domain/shop/entities/booking_entity.dart';

abstract class GetBookingState extends Equatable {
  final List<BookingEntity> bookingList;

  const GetBookingState({required this.bookingList});
}

class GetBookingInitial extends GetBookingState {
  const GetBookingInitial({required super.bookingList});

  @override
  List<Object?> get props => [];
}

class GetBookingLoading extends GetBookingState {
  const GetBookingLoading({required super.bookingList});

  @override
  List<Object?> get props => [];
}

class GetBookingLoaded extends GetBookingState {
  const GetBookingLoaded({required super.bookingList});

  @override
  List<Object?> get props => bookingList;
}

class GetBookingFailure extends GetBookingState {
  const GetBookingFailure({
    required this.message,
    required super.bookingList,
  });
  final String message;
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
