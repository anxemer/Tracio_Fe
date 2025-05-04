import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/shop/models/create_service_req.dart';
import 'package:tracio_fe/data/shop/models/create_shop_profile_req.dart';
import 'package:tracio_fe/data/shop/models/get_booking_req.dart';
import 'package:tracio_fe/data/shop/models/get_review_req.dart';
import 'package:tracio_fe/data/shop/models/reschedule_booking_model.dart';
import 'package:tracio_fe/data/shop/models/review_booking_req.dart';
import 'package:tracio_fe/data/shop/models/waiting_booking.dart';
import 'package:tracio_fe/domain/blog/entites/category.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_detail_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/cart_item_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/detail_service_response_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/review_service_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/review_service_response_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/shop_profile_entity.dart';

import '../../../data/shop/models/booking_service_req.dart';
import '../../../data/shop/models/get_service_req.dart';
import '../../../data/shop/models/reply_review_req.dart';
import '../entities/response/booking_response_entity.dart';
import '../entities/response/service_response_entity.dart';

abstract class ShopServiceRepository {
  Future<Either<Failure, ServiceResponseEntity>> getService(
      GetServiceReq serviceReq);
  Future<Either<Failure, ServiceResponseEntity>> getMineService();
  Future<Either<Failure, ReviewServiceResponseEntity>> getReviewService(
      GetReviewReq serviceReq);
  Future<Either<Failure, ReviewServiceEntity>> getReviewBooking(
      int bookingDetailid);
  Future<Either<Failure, bool>> addToCard(int serviceId);
  Future<Either<Failure, List<CartItemEntity>>> getCartitem();
  Future<Either<Failure, List<CategoryEntity>>> getCateService();
  Future<Either<Failure, bool>> bookingService(BookingServiceReq booking);
  Future<Either<Failure, bool>> createService(CreateServiceReq createService);
  Future<Either<Failure, bool>> registerShop(CreateShopProfileReq createShop);
  Future<Either<Failure, bool>> eidtShop(CreateShopProfileReq createShop);
  Future<Either<Failure, bool>> deleteService(int serviceId);
  Future<Either<Failure, BookingResponseEntity>> getBooking(
      GetBookingReq getBooking);
  Future<Either<Failure, BookingDetailEntity>> getBookingDetail(int bookingId);
  Future<Either<Failure, DetailServiceResponseEntity>> getServiceDetail(
      int serviceId);
  Future<Either<Failure, bool>> delelteCartItem(int itemId);
  Future<Either<Failure, bool>> processBooking(int bookingDetailId);
  Future<Either<Failure, bool>> cancelBooking(int bookingDetailId);
  Future<Either<Failure, bool>> completeBooking(int bookingDetailId);
  Future<Either<Failure, bool>> reviewBooking(ReviewBookingReq review);
  Future<Either<Failure, bool>> replyReview(ReplyReviewReq reply);
  Future<Either<Failure, bool>> rescheduleBooking(
      RescheduleBookingModel reschedule);
  Future<Either<Failure, bool>> confirmBooking(ConfirmBookingModel waiting);
  Future<Either<Failure, ShopProfileEntity>> getShopProfile();
}
