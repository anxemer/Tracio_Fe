// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/shop/models/booking_service_req.dart';
import 'package:tracio_fe/data/shop/source/shop_api_service.dart';
import 'package:tracio_fe/domain/blog/entites/category.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_response_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/cart_item_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/service_response_entity.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../core/erorr/failure.dart';
import '../models/get_booking_req.dart';
import '../models/get_service_req.dart';

class ShopServiceRepositoryImpl extends ShopServiceRepository {
  final ShopApiService remoteDataSource;
  ShopServiceRepositoryImpl({
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, ServiceResponseEntity>> getService(GetServiceReq serviceReq) async {
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
  Future<Either<Failure, BookingResponseEntity>> getBooking(GetBookingReq getBooking) async {
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
}
