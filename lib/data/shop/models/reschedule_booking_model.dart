// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'booking_service_req.dart';

class RescheduleBookingModel {
  final List<int> bookingIds;
  final List<UserScheduleCreateDto>? userScheduleCreateDtos;
  RescheduleBookingModel({
    required this.bookingIds,
    this.userScheduleCreateDtos,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookingIds': bookingIds,
      'userScheduleCreateDtos':
          userScheduleCreateDtos?.map((x) => x.toMap()).toList(),
    };
  }

  RescheduleBookingModel copyWith({
    List<int>? bookingIds,
    List<UserScheduleCreateDto>? userScheduleCreateDtos,
  }) {
    return RescheduleBookingModel(
      bookingIds: bookingIds ?? this.bookingIds,
      userScheduleCreateDtos:
          userScheduleCreateDtos ?? this.userScheduleCreateDtos,
    );
  }
  // factory RescheduleBookingModel.fromMap(Map<String, dynamic> map) {
  //   return RescheduleBookingModel(
  //     bookingIds: List<int>.from((map['bookingIds'] as List<int>),
  //     userScheduleCreateDtos: List<UserScheduleCreateDto>.from((map['userScheduleCreateDtos'] as List<int>).map<UserScheduleCreateDto>((x) => UserScheduleCreateDto.fromMap(x as Map<String,dynamic>),),),
  //   );
  // }
}
