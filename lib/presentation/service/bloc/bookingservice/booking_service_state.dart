// ignore_for_file: public_member_api_docs, sort_constructors_first
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
