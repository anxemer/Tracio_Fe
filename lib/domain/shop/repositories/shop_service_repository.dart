import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/shop/models/get_booking_req.dart';
import 'package:tracio_fe/domain/blog/entites/category.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/cart_item_entity.dart';

import '../../../data/shop/models/booking_service_req.dart';
import '../../../data/shop/models/get_service_req.dart';
import '../entities/response/booking_response_entity.dart';
import '../entities/response/service_response_entity.dart';

abstract class ShopServiceRepository {
  Future<Either<Failure, ServiceResponseEntity>> getService(GetServiceReq serviceReq);
  Future<Either<Failure, bool>> addToCard(int serviceId);
  Future<Either<Failure, List<CartItemEntity>>> getCartitem();
  Future<Either<Failure, List<CategoryEntity>>> getCateService();
  Future<Either<Failure, bool>> bookingService(BookingServiceReq booking);
  Future<Either<Failure, BookingResponseEntity>> getBooking(GetBookingReq getBooking);
  Future<Either<Failure, bool>> delelteCartItem(int itemId);
}
