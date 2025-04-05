import 'package:tracio_fe/domain/shop/entities/response/pagination_booking_data_entity.dart';

class PaginationBookingDataModel extends PaginationBookingDataEntity {
  PaginationBookingDataModel({
    super.totalBookings,
    super.totalPages,
    super.pageNumber,
    super.pageSize,
    super.hasNextPage,
    super.hasPreviousPage,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalBookings': totalBookings,
      'totalPages': totalPages,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  factory PaginationBookingDataModel.fromMap(Map<String, dynamic> map) {
    return PaginationBookingDataModel(
      totalBookings:
          map['totalBookings'] != null ? map['totalBookings'] as int : null,
      totalPages: map['totalPages'] != null ? map['totalPages'] as int : null,
      pageNumber: map['pageNumber'] != null ? map['pageNumber'] as int : null,
      pageSize: map['pageSize'] != null ? map['pageSize'] as int : null,
      hasNextPage:
          map['hasNextPage'] != null ? map['hasNextPage'] as bool : null,
      hasPreviousPage: map['hasPreviousPage'] != null
          ? map['hasPreviousPage'] as bool
          : null,
    );
  }
}
