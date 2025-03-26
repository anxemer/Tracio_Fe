import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/domain/blog/entites/category.dart';
import 'package:tracio_fe/domain/shop/entities/booking_entity.dart';
import 'package:tracio_fe/domain/shop/entities/cart_item_entity.dart';

import '../../../data/shop/models/booking_service_req.dart';
import '../entities/service_response_entity.dart';

abstract class ShopServiceRepository {
  Future<Either<Failure, ServiceResponseEntity>> getService();
  Future<Either<Failure, bool>> addToCard(int serviceId);
  Future<Either<Failure, List<CartItemEntity>>> getCartitem();
  Future<Either<Failure, List<CategoryEntity>>> getCateService();
  Future<Either<Failure, bool>> bookingService(BookingServiceReq booking);
  Future<Either<Failure, List<BookingEntity>>> getBooking();
}
