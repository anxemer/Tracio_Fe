// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

abstract class ResolveBookingShopState extends Equatable {
  final DateTime? bookedDate;
  final String? shopNote;
  final String? price;
  final String? reason;
  final String? adjPrice;

  const ResolveBookingShopState({
    this.bookedDate,
    this.shopNote,
    this.price,
    this.reason,
    this.adjPrice,
  });

  @override
  List<Object?> get props => [
        bookedDate,
        shopNote,
        price,
        reason,
      ];
}

class ResolveShopBookingInitial extends ResolveBookingShopState {
  const ResolveShopBookingInitial();

  @override
  List<Object?> get props => [];
}

class ConfirmBookingInittial extends ResolveBookingShopState {
  const ConfirmBookingInittial();

  @override
  List<Object?> get props => [];
}

class ConfirmBookingLoading extends ResolveBookingShopState {
  const ConfirmBookingLoading();

  @override
  List<Object?> get props => [];
}

class ConfirmBookingSuccess extends ResolveBookingShopState {
  const ConfirmBookingSuccess({
    DateTime? selectedBookedDate,
    super.shopNote,
    super.price,
    super.reason,
  }) : super(
          bookedDate: selectedBookedDate,
        );
}

class ResolveBookingFailure extends ResolveBookingShopState {
  final String messgae;
  const ResolveBookingFailure({
    required this.messgae,
  });
  @override
  List<Object?> get props => [];
}

class ResolveBookingSuccess extends ResolveBookingShopState {
  @override
  List<Object?> get props => [];
}

class WaitingBookingFailure extends ResolveBookingShopState {
  const WaitingBookingFailure();

  @override
  List<Object?> get props => [];
}

class UpdateParamsWaitingBooking extends ResolveBookingShopState {
  const UpdateParamsWaitingBooking({
    super.bookedDate,
    super.shopNote,
    super.price,
    super.reason,
    super.adjPrice,
  });
}
