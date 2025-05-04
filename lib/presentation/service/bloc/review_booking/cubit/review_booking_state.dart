part of 'review_booking_cubit.dart';

sealed class ReviewBookingState extends Equatable {
  const ReviewBookingState();

  @override
  List<Object> get props => [];
}

final class ReviewBookingInitial extends ReviewBookingState {}

final class ReviewBookingLoading extends ReviewBookingState {}

final class ReviewBookingSuccess extends ReviewBookingState {}

final class ReviewBookingFailure extends ReviewBookingState {
  final String message;

  const ReviewBookingFailure(this.message);

  @override
  List<Object> get props => [message];
}
