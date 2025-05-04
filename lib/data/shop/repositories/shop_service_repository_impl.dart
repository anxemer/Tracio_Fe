// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/shop/models/booking_service_req.dart';
import 'package:tracio_fe/data/shop/models/create_service_req.dart';
import 'package:tracio_fe/data/shop/models/create_shop_profile_req.dart';
import 'package:tracio_fe/data/shop/models/get_review_req.dart';
import 'package:tracio_fe/data/shop/models/reschedule_booking_model.dart';
import 'package:tracio_fe/data/shop/models/review_booking_req.dart';
import 'package:tracio_fe/data/shop/models/waiting_booking.dart';
import 'package:tracio_fe/data/shop/source/shop_api_service.dart';
import 'package:tracio_fe/domain/blog/entites/category.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_detail_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_response_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/cart_item_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/detail_service_response_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/review_service_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/review_service_response_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/service_response_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/shop_profile_entity.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../core/erorr/failure.dart';
import '../models/get_booking_req.dart';
import '../models/get_service_req.dart';
import '../models/reply_review_req.dart';

class ShopServiceRepositoryImpl extends ShopServiceRepository {
  final ShopApiService remoteDataSource;
  ShopServiceRepositoryImpl({
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, ServiceResponseEntity>> getService(
      GetServiceReq serviceReq) async {
    try {
      var returnedData = await remoteDataSource.getService(serviceReq);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> addToCard(int serviceId) async {
    try {
      await remoteDataSource.addToCart(serviceId);
      return Right(true);
    } on Failure catch (e) {
      return Left(ExceptionFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartitem() async {
    try {
      var returnedData = await remoteDataSource.getCartItem();
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCateService() async {
    try {
      var returnData = await remoteDataSource.getCategoryService();
      return Right(returnData);
    } on Failure catch (e) {
      return Left(ExceptionFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> bookingService(
      BookingServiceReq booking) async {
    try {
      await remoteDataSource.bookingService(booking);
      return Right(true);
    } on ExceptionFailure catch (e) {
      return Left(ExceptionFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BookingResponseEntity>> getBooking(
      GetBookingReq getBooking) async {
    try {
      var returnedData = await remoteDataSource.getBooking(getBooking);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> delelteCartItem(int itemId) async {
    try {
      await remoteDataSource.deleteCartItem(itemId);
      return Right(true);
    } on ExceptionFailure {
      return Left(ExceptionFailure('Add to cart failure'));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> processBooking(int bookingDetailId) async {
    try {
      await remoteDataSource.processBooking(bookingDetailId);
      return Right(true);
    } on ExceptionFailure {
      return Left(ExceptionFailure('Submit service fail'));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelBooking(int bookingDetailId) async {
    try {
      await remoteDataSource.cancelBooking(bookingDetailId);
      return Right(true);
    } on ExceptionFailure {
      return Left(ExceptionFailure('cancel service fail'));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> rescheduleBooking(
      RescheduleBookingModel reschedule) async {
    try {
      await remoteDataSource.rescheduleBooking(reschedule);
      return Right(true);
    } on ExceptionFailure catch (e) {
      return Left(ExceptionFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BookingDetailEntity>> getBookingDetail(
      int bookingId) async {
    try {
      var returnedData = await remoteDataSource.getBookingDetail(bookingId);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> confirmBooking(
      ConfirmBookingModel waiting) async {
    try {
      await remoteDataSource.confirmBooking(waiting);
      return Right(true);
    } on ExceptionFailure catch (e) {
      return Left(ExceptionFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> completeBooking(int bookingDetailId) async {
    try {
      await remoteDataSource.completeBooking(bookingDetailId);
      return Right(true);
    } on ExceptionFailure catch (e) {
      return Left(ExceptionFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ReviewServiceResponseEntity>> getReviewService(
      GetReviewReq serviceReq) async {
    try {
      var returnedData = await remoteDataSource.getReviewService(serviceReq);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, ShopProfileEntity>> getShopProfile() async {
    try {
      var returnedData = await remoteDataSource.getShopProfile();
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> reviewBooking(ReviewBookingReq review) async {
    try {
      await remoteDataSource.reviewBooking(review);
      return Right(true);
    } on ExceptionFailure {
      return Left(ExceptionFailure('Submit service fail'));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> createService(
      CreateServiceReq createService) async {
    try {
      await remoteDataSource.createService(createService);
      return Right(true);
    } on ExceptionFailure {
      return Left(ExceptionFailure('Submit service fail'));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, DetailServiceResponseEntity>> getServiceDetail(
      int serviceId) async {
    try {
      var returnedData = await remoteDataSource.getServiceDetail(serviceId);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, ReviewServiceEntity>> getReviewBooking(
      int bookingDetailid) async {
    try {
      var returnedData =
          await remoteDataSource.getReviewBooking(bookingDetailid);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteService(int serviceId) async {
    try {
      await remoteDataSource.deleteService(serviceId);
      return Right(true);
    } on ExceptionFailure catch (e) {
      return Left(ExceptionFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ServiceResponseEntity>> getMineService() async {
    try {
      var returnedData = await remoteDataSource.getMineService();
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> replyReview(ReplyReviewReq reply) async {
    try {
      await remoteDataSource.replyReview(reply);
      return Right(true);
    } on ExceptionFailure {
      return Left(ExceptionFailure('Submit service fail'));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> registerShop(
      CreateShopProfileReq createShop) async {
    try {
      await remoteDataSource.registerShopProfile(createShop);
      return Right(true);
    } on ExceptionFailure {
      return Left(ExceptionFailure('Submit service fail'));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> eidtShop(
      CreateShopProfileReq createShop) async {
    try {
      await remoteDataSource.editShopProfile(createShop);
      return Right(true);
    } on ExceptionFailure {
      return Left(ExceptionFailure('Submit service fail'));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }
}
