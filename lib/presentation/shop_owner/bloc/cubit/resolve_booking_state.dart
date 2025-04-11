// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class ResolveBookingShopState extends Equatable {}

class ResolveShopBookingInitial extends ResolveBookingShopState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WaitingBookingInittial extends ResolveBookingShopState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WaitingBookingLoading extends ResolveBookingShopState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WaitingBookingSuccess extends ResolveBookingShopState {
  final DateTime? selectedBookedDate;
  final DateTime? selectedEndDate;
  final String? shopNote;
  final double? price;
  WaitingBookingSuccess({
    this.selectedBookedDate,
    this.selectedEndDate,
    this.shopNote,
    this.price,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WaitingBookingFailure extends ResolveBookingShopState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UpdateParamsWaitingBooking extends ResolveBookingShopState {
  final DateTime? bookedDate;
  final DateTime? estimatedEndDate;
  final String? shopNote;
  UpdateParamsWaitingBooking({
    this.bookedDate,
    this.estimatedEndDate,
    this.shopNote,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [bookedDate, estimatedEndDate, shopNote];
}
 // ResolveBookingShopState copyWith({
  //   Object? selectedBookedDate = const Object(),
  //   Object? selectedEndDate = const Object(),
  // }) {
  //   return ResolveBookingShopState(
  //     selectedBookedDate: selectedBookedDate == const Object()
  //         ? this.selectedBookedDate
  //         : selectedBookedDate as DateTime?,
  //     selectedEndDate: selectedEndDate == const Object()
  //         ? this.selectedEndDate
  //         : selectedEndDate as DateTime?,
  //   );
  // }