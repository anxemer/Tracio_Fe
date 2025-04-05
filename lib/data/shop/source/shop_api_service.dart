import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:tracio_fe/data/shop/models/booking_model.dart';
import 'package:tracio_fe/data/shop/models/booking_response_model.dart';
import 'package:tracio_fe/data/shop/models/booking_service_req.dart';
import 'package:tracio_fe/data/shop/models/cart_item_models.dart';
import 'package:tracio_fe/data/shop/models/get_booking_req.dart';
import 'package:tracio_fe/data/shop/models/get_service_req.dart';
import 'package:tracio_fe/data/shop/models/service_response.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_response_entity.dart';

import '../../../core/constants/api_url.dart';
import '../../../core/erorr/failure.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';
import '../../blog/models/response/category_model.dart';

abstract class ShopApiService {
  Future<ServiceResponseModel> getService(GetServiceReq serviceReq);
  Future<Either> addToCart(int serviceId);
  Future<List<CartItemModel>> getCartItem();
  Future<List<CategoryModel>> getCategoryService();
  Future<Either> bookingService(BookingServiceReq booking);
  Future<BookingResponseModel> getBooking(GetBookingReq getBooking);
  Future<Either> deleteCartItem(int itemId);
}

class ShopApiServiceImpl extends ShopApiService {
  @override
  Future<ServiceResponseModel> getService(GetServiceReq serviceReq) async {
    Uri apiUrl = ApiUrl.urlGetService(serviceReq.toQueryParams());

    var response = await sl<DioClient>().get(apiUrl.toString());
    if (response.statusCode == 200) {
      return ServiceResponseModel.fromMap(response.data['result']);
    } else {
      if (response.statusCode == 401) {
        throw AuthenticationFailure(response.statusMessage.toString());
      }
      throw ServerFailure(response.statusMessage.toString());
    }
  }

  @override
  Future<Either> addToCart(int serviceId) async {
    var response =
        await sl<DioClient>().post(ApiUrl.addToCart, data: serviceId);
    if (response.statusCode == 400) {
      throw ExceptionFailure(response.statusMessage!);
    }
    return Right(true);
  }

  @override
  Future<List<CartItemModel>> getCartItem() async {
    var response = await sl<DioClient>().get(ApiUrl.getCartItem);
    if (response.statusCode == 200) {
      if (response.data['result']['cartItems'] == null) {
        return [];
      }
      return List.from(response.data['result']['cartItems'])
          .map((e) => CartItemModel.fromJson(e))
          .toList();
    } else {
      if (response.statusCode == 401) {
        throw AuthenticationFailure(response.statusMessage.toString());
      }
      throw ServerFailure(response.statusMessage.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCategoryService() async {
    try {
      var response = await sl<DioClient>().get(ApiUrl.getCateService);
      if (response.statusCode == 200) {
        return List<CategoryModel>.from(response.data['result']['categories']
            .map((c) => CategoryModel.fromMap(c)));
      }
      return [];
    } on DioException catch (e) {
      return [];
    }
  }

  @override
  Future<Either> bookingService(BookingServiceReq booking) async {
    try {
      var response = await sl<DioClient>()
          .post(ApiUrl.bookingService, data: booking.toMap());
      if (response.statusCode == 201) {
        return Right(true);
      }
      return Right(false);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<BookingResponseModel> getBooking(GetBookingReq getBooking) async {
    Uri apiUrl = ApiUrl.urlGetBooking(getBooking.toQueryParams());
    var response = await sl<DioClient>().get(apiUrl.toString());
    if (response.statusCode == 200) {
      return BookingResponseModel.fromMap(response.data['result']);
      // List.from(response.data['result']['bookings'])
      //     .map((e) => BookingModel.fromMap(e))
      //     .toList();
    } else {
      if (response.statusCode == 401) {
        throw AuthenticationFailure(response.statusMessage.toString());
      }
      throw ServerFailure(response.statusMessage.toString());
    }
  }

  @override
  Future<Either> deleteCartItem(int itemId) async {
    try {
      await sl<DioClient>().delete('${ApiUrl.deleteCartItem}/${itemId}');

      return Right(true);
    } on DioException catch (e) {
      return Left(e);
    }
  }
}
