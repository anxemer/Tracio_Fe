import 'package:Tracio/data/shop/models/get_detail_service_req.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:Tracio/data/shop/models/booking_detail_model.dart';

import 'package:Tracio/data/shop/models/booking_response_model.dart';
import 'package:Tracio/data/shop/models/booking_service_req.dart';
import 'package:Tracio/data/shop/models/cart_item_models.dart';
import 'package:Tracio/data/shop/models/create_service_req.dart';
import 'package:Tracio/data/shop/models/create_shop_profile_req.dart';
import 'package:Tracio/data/shop/models/detail_service_response_model.dart';
import 'package:Tracio/data/shop/models/get_booking_req.dart';
import 'package:Tracio/data/shop/models/get_review_req.dart';
import 'package:Tracio/data/shop/models/get_service_req.dart';
import 'package:Tracio/data/shop/models/reply_review_req.dart';
import 'package:Tracio/data/shop/models/reschedule_booking_model.dart';
import 'package:Tracio/data/shop/models/review_booking_req.dart';
import 'package:Tracio/data/shop/models/review_service_response_model.dart';
import 'package:Tracio/data/shop/models/service_response.dart';
import 'package:Tracio/data/shop/models/shop_profile_model.dart';
import 'package:Tracio/data/shop/models/waiting_booking.dart';

import '../../../core/constants/api_url.dart';
import '../../../core/erorr/failure.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';
import '../../blog/models/response/category_model.dart';
import '../models/review_service_model.dart';

abstract class ShopApiService {
  Future<ServiceResponseModel> getService(GetServiceReq serviceReq);
  Future<ServiceResponseModel> getMineService();
  Future<ReviewServiceResponseModel> getReviewService(
      GetReviewReq getServiceReq);
  Future<ReviewServiceModel> getReviewBooking(int bookingDetailId);
  Future<Either> addToCart(int serviceId);
  Future<List<CartItemModel>> getCartItem();
  Future<List<CategoryModel>> getCategoryService();
  Future<Either> bookingService(BookingServiceReq booking);
  Future<BookingResponseModel> getBooking(GetBookingReq getBooking);
  Future<BookingDetailModel> getBookingDetail(int bookingId);
  Future<DetailServiceResponseModel> getServiceDetail(
      GetDetailServiceReq serviceId);
  Future<Either> deleteCartItem(int itemId);
  Future<Either> processBooking(int bookingDetailId);
  Future<Either> cancelBooking(ConfirmBookingModel cancelBooking);
  Future<Either> completeBooking(int bookingDetailId);
  Future<Either> rescheduleBooking(RescheduleBookingModel reschedule);
  Future<Either> confirmBooking(ConfirmBookingModel waiting);
  Future<Either> reviewBooking(ReviewBookingReq review);
  Future<ShopProfileModel> getShopProfile();
  Future<Either> createService(CreateServiceReq createService);
  Future<Either> registerShopProfile(CreateShopProfileReq createShop);
  Future<Either> editShopProfile(CreateShopProfileReq createShop);
  Future<Either> deleteService(int serviceId);
  Future<Either> replyReview(ReplyReviewReq reply);
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
      if (response.statusCode == 400) {
        throw CredentialFailure('Shop is Inactive');
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
      await sl<DioClient>().delete('${ApiUrl.deleteCartItem}/$itemId');

      return Right(true);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> processBooking(int bookingDetailId) async {
    try {
      await sl<DioClient>()
          .put('${ApiUrl.bookingService}/$bookingDetailId/processing-booking');

      return Right(true);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> cancelBooking(ConfirmBookingModel cancelBooking) async {
    try {
      await sl<DioClient>().put(
          '${ApiUrl.bookingService}/${cancelBooking.bookingId}/cancelled-booking',
          data: cancelBooking.toJson());

      return Right(true);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> completeBooking(int bookingDetailId) async {
    try {
      await sl<DioClient>()
          .put('${ApiUrl.bookingService}/$bookingDetailId/completed-booking');

      return Right(true);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> rescheduleBooking(RescheduleBookingModel reschedule) async {
    try {
      var response = await sl<DioClient>()
          .put(ApiUrl.rescheduleBooking, data: reschedule.toMap());
      print("🔥 Sending reschedule: ${reschedule.toMap()}");
      if (response.statusCode == 201) {
        return Right(true);
      }
      return Right(false);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<BookingDetailModel> getBookingDetail(int bookingId) async {
    var response = await sl<DioClient>()
        .get('${ApiUrl.bookingService}/$bookingId/booking-details');
    if (response.statusCode == 200) {
      return BookingDetailModel.fromJson(
          response.data['result']['bookingDetail']);
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
  Future<Either> confirmBooking(ConfirmBookingModel confirmModel) async {
    try {
      var response = await sl<DioClient>().put(
          '${ApiUrl.bookingService}/${confirmModel.bookingId}/confirmed-booking',
          data: confirmModel.toJson());
      if (response.statusCode == 200) {
        return Right(true);
      }
      return Right(false);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<ReviewServiceResponseModel> getReviewService(
      GetReviewReq getReviewReq) async {
    Uri apiUrl = ApiUrl.urlGetReviewService(
        getReviewReq.seriveId, getReviewReq.toQueryParams());

    var response = await sl<DioClient>().get(apiUrl.toString());
    if (response.statusCode == 200) {
      return ReviewServiceResponseModel.fromMap(response.data);
    } else {
      if (response.statusCode == 401) {
        throw AuthenticationFailure(response.statusMessage.toString());
      }
      throw ServerFailure(response.statusMessage.toString());
    }
  }

  @override
  Future<ShopProfileModel> getShopProfile() async {
    var response = await sl<DioClient>().get(ApiUrl.getShopProfile);
    if (response.statusCode == 200) {
      return ShopProfileModel.fromJson(response.data['result']);
    } else {
      if (response.statusCode == 401) {
        throw AuthenticationFailure(response.statusMessage.toString());
      }
      throw ServerFailure(response.statusMessage.toString());
    }
  }

  @override
  Future<Either> reviewBooking(ReviewBookingReq review) async {
    try {
      FormData formData = await review.toFormData();
      var response = await sl<DioClient>()
          .post(ApiUrl.reviewBooking, data: formData, isMultipart: true);
      if (response.statusCode == 201) {
        return Right(true);
      }
      return Right(false);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> createService(CreateServiceReq createService) async {
    try {
      FormData formData = await createService.toFormData();
      var response = await sl<DioClient>()
          .post(ApiUrl.apiService, data: formData, isMultipart: true);
      if (response.statusCode == 201) {
        return Right(true);
      }
      if (response.statusCode == 401) {
        return Left(AuthenticationFailure(''));
      }
      return Right(false);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<DetailServiceResponseModel> getServiceDetail(
      GetDetailServiceReq service) async {
    Uri apiUrl =
        ApiUrl.urlGetDetailService(service.serviceId!, service.toQueryParams());

    var response = await sl<DioClient>().get(apiUrl.toString());
    if (response.statusCode == 200) {
      return DetailServiceResponseModel.fromMap(response.data['result']);
    } else {
      if (response.statusCode == 401) {
        throw AuthenticationFailure(response.statusMessage.toString());
      }
      throw ServerFailure(response.statusMessage.toString());
    }
  }

  @override
  Future<ReviewServiceModel> getReviewBooking(int bookingDetailId) async {
    var response = await sl<DioClient>()
        .get('${ApiUrl.bookingService}/$bookingDetailId/review');

    if (response.statusCode == 200) {
      final result = response.data['result'];
      if (result != null) {
        return ReviewServiceModel.fromJson(result);
      } else {
        return ReviewServiceModel.empty();
      }
    } else {
      if (response.statusCode == 401) {
        throw AuthenticationFailure(response.statusMessage.toString());
      }
      throw ServerFailure(response.statusMessage.toString());
    }
  }

  @override
  Future<Either> deleteService(int serviceId) async {
    try {
      await sl<DioClient>().delete('${ApiUrl.apiService}/$serviceId');
      return Right(true);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<ServiceResponseModel> getMineService() async {
    var response = await sl<DioClient>().get('${ApiUrl.apiService}/mine');
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
  Future<Either> replyReview(ReplyReviewReq reply) async {
    try {
      var response = await sl<DioClient>()
          .post(ApiUrl.replyReview, data: reply.toMap(), isMultipart: false);
      if (response.statusCode == 201) {
        return Right(true);
      } else if (response.statusCode == 404) {
        throw CredentialFailure(response.statusMessage.toString());
      }
      return Right(false);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> registerShopProfile(CreateShopProfileReq createShop) async {
    try {
      FormData formData = await createShop.toFormData();
      var response = await sl<DioClient>()
          .post(ApiUrl.registerShop, data: formData, isMultipart: true);
      if (response.statusCode == 201) {
        return Right(true);
      }
      if (response.statusCode == 401) {
        return Left(AuthenticationFailure(''));
      }
      return Right(false);
    } on DioException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> editShopProfile(CreateShopProfileReq createShop) async {
    try {
      FormData formData = await createShop.toFormData();
      var response = await sl<DioClient>().put(ApiUrl.editShop, data: formData);
      if (response.statusCode == 200) {
        return Right(true);
      }
      if (response.statusCode == 401) {
        return Left(AuthenticationFailure(''));
      }
      if (response.statusCode == 404) {
        return Left(ExceptionFailure(''));
      }
      return Left(false);
    } on DioException catch (e) {
      return Left(e);
    }
  }
}
