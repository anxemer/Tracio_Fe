// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookingServiceReq {
  BookingServiceReq({
    this.bookingCartCreateDtos,
    this.bookingCreateDto,
    required this.userScheduleCreateDtos,
  });

  final List<BookingCartCreateDto>? bookingCartCreateDtos;
  final BookingCreateDto? bookingCreateDto;
  final List<UserScheduleCreateDto> userScheduleCreateDtos;

  // factory BookingReq.fromJson(Map<String, dynamic> json) {
  //   return BookingReq(
  //     bookingCartCreateDtos: json["bookingCartCreateDtos"] == null
  //         ? []
  //         : List<BookingCartCreateDto>.from(json["bookingCartCreateDtos"]!
  //             .map((x) => BookingCartCreateDto.fromJson(x))),
  //     bookingCreateDto: json["bookingCreateDto"] == null
  //         ? null
  //         : BookingCreateDto.fromJson(json["bookingCreateDto"]),
  //     userScheduleCreateDtos: json["userScheduleCreateDtos"] == null
  //         ? []
  //         : List<UserScheduleCreateDto>.from(json["userScheduleCreateDtos"]!
  //             .map((x) => UserScheduleCreateDto.fromJson(x))),
  //   );
  // }

  // Map<String, dynamic> toJson() => {
  //       "bookingCartCreateDtos":
  //           bookingCartCreateDtos?.map((x) => x?.toJson()).toList(),
  //       "bookingCreateDto": bookingCreateDto?.toJson(),
  //       "userScheduleCreateDtos":
  //           userScheduleCreateDtos.map((x) => x?.toJson()).toList(),
  //     };

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userScheduleCreateDtos':
          userScheduleCreateDtos.map((x) => x.toMap()).toList(),
    };

    // Only include one of these fields based on which one is not null
    if (bookingCartCreateDtos != null && bookingCartCreateDtos!.isNotEmpty) {
      map['bookingCartCreateDtos'] =
          bookingCartCreateDtos!.map((x) => x.toJson()).toList();
    } else if (bookingCreateDto != null) {
      map['bookingCreateDto'] = bookingCreateDto!.toJson();
    }

    return map;
  }

  factory BookingServiceReq.fromMap(Map<String, dynamic> map) {
    return BookingServiceReq(
      bookingCartCreateDtos: map['bookingCartCreateDtos'] != null
          ? List<BookingCartCreateDto>.from(
              (map['bookingCartCreateDtos'] as List<int>)
                  .map<BookingCartCreateDto?>(
                (x) => BookingCartCreateDto.fromJson(x as Map<String, dynamic>),
              ),
            )
          : null,
      bookingCreateDto: map['bookingCreateDto'] != null
          ? BookingCreateDto.fromJson(
              map['bookingCreateDto'] as Map<String, dynamic>)
          : null,
      userScheduleCreateDtos: List<UserScheduleCreateDto>.from(
        (map['userScheduleCreateDtos'] as List<int>).map<UserScheduleCreateDto>(
          (x) => UserScheduleCreateDto.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingServiceReq.fromJson(String source) =>
      BookingServiceReq.fromMap(json.decode(source) as Map<String, dynamic>);
}

class BookingCartCreateDto {
  BookingCartCreateDto({
    required this.bookingQueueId,
    required this.note,
  });

  final int? bookingQueueId;
  final String? note;

  factory BookingCartCreateDto.fromJson(Map<String, dynamic> json) {
    return BookingCartCreateDto(
      bookingQueueId: json["itemId"],
      note: json["note"],
    );
  }

  Map<String, dynamic> toJson() => {
        "itemId": bookingQueueId,
        "note": note,
      };
}

class BookingCreateDto {
  BookingCreateDto({
    required this.serviceId,
    required this.note,
  });

  final int? serviceId;
  final String? note;

  factory BookingCreateDto.fromJson(Map<String, dynamic> json) {
    return BookingCreateDto(
      serviceId: json["serviceId"],
      note: json["note"],
    );
  }

  Map<String, dynamic> toJson() => {
        "serviceId": serviceId,
        "note": note,
      };
}

class UserScheduleCreateDto {
  UserScheduleCreateDto({
    required this.date,
    required this.timeFrom,
    required this.timeTo,
  });

  final DateTime? date;
  final String? timeFrom;
  final String? timeTo;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': _formatDate(date!),
      'timeFrom': timeFrom,
      'timeTo': timeTo,
    };
  }

  factory UserScheduleCreateDto.fromMap(Map<String, dynamic> map) {
    return UserScheduleCreateDto(
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int)
          : null,
      timeFrom: map['timeFrom'] != null ? map['timeFrom'] as String : null,
      timeTo: map['timeTo'] != null ? map['timeTo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserScheduleCreateDto.fromJson(String source) =>
      UserScheduleCreateDto.fromMap(
          json.decode(source) as Map<String, dynamic>);
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
