import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/shop/models/get_booking_req.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_entity.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';
import '../entities/response/booking_response_entity.dart';

class GetBookingUseCase extends Usecase<BookingResponseEntity, GetBookingReq> {
  @override
  Future<Either<Failure, BookingResponseEntity>> call(
      GetBookingReq params) async {
    return await sl<ShopServiceRepository>().getBooking(params);
  }
}
