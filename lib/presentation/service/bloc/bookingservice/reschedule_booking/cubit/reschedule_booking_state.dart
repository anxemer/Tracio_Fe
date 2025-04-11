// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'reschedule_booking_cubit.dart';

sealed class ResolveBookingState extends Equatable {
  const ResolveBookingState();

  @override
  List<Object> get props => [];
}

final class RescheduleBookingInitial extends ResolveBookingState {}

final class RescheduleBookingLoading extends ResolveBookingState {}

class RescheduleBookingSuccess extends ResolveBookingState {
  final bool isSuccess;
  RescheduleBookingSuccess({
    required this.isSuccess,
  });
}

class RescheduleBookingFailure extends ResolveBookingState {
  final String message;
  RescheduleBookingFailure({
    required this.message,
  });
}
