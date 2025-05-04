part of 'get_booking_detail_cubit.dart';

sealed class GetBookingDetailState extends Equatable {
  const GetBookingDetailState();
  @override
  List<Object> get props => [];
}

final class GetBookingDetailInitial extends GetBookingDetailState {
  const GetBookingDetailInitial();
  @override
  List<Object> get props => [];
}

final class GetBookingDetailLoading extends GetBookingDetailState {
  const GetBookingDetailLoading();
  @override
  List<Object> get props => [];
}

final class GetBookingDetailLoaded extends GetBookingDetailState {
  const GetBookingDetailLoaded(this.bookingdetail);
  final BookingDetailEntity bookingdetail;
  @override
  List<Object> get props => [bookingdetail];
}

final class GetBookingDetailFailure extends GetBookingDetailState {
  const GetBookingDetailFailure(this.message, this.failure);
  final String message;
  final Failure failure;
  @override
  List<Object> get props => [];
}
