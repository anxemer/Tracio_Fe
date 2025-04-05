class BookingServiceReqEntity {
  BookingServiceReqEntity({
    required this.bookingCartCreateDtos,
    required this.bookingCreateDto,
    required this.userScheduleCreateDtos,
  });

  final List<BookingCartCreateEntity> ? bookingCartCreateDtos;
  final BookingCreateEntity? bookingCreateDto;
  final List<UserScheduleCreateEntity> userScheduleCreateDtos;
}

class BookingCartCreateEntity {
  BookingCartCreateEntity({
    required this.bookingQueueId,
    required this.note,
  });

  final int? bookingQueueId;
  final String? note;
}

class BookingCreateEntity {
  BookingCreateEntity({
    required this.serviceId,
    required this.note,
  });

  final int? serviceId;
  final String? note;
}

class UserScheduleCreateEntity {
  UserScheduleCreateEntity({
    required this.date,
    required this.timeFrom,
    required this.timeTo,
  });

  final DateTime? date;
  final String? timeFrom;
  final String? timeTo;
}
