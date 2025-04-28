import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class ReactionApiService {
  Future<Either<Failure, dynamic>> getReactRoute(int routeId);
  Future<Either<Failure, dynamic>> postReactRoute(int routeId);
  Future<Either<Failure, dynamic>> deleteReactRoute(int routeId);

  Future<Either<Failure, dynamic>> getReactReview(int reviewId);
  Future<Either<Failure, dynamic>> postReactReview(int reviewId);
  Future<Either<Failure, dynamic>> deleteReactReview(int reviewId);

  Future<Either<Failure, dynamic>> getReactReply(int replyId);
  Future<Either<Failure, dynamic>> postReactReply(int replyId);
  Future<Either<Failure, dynamic>> deleteReactReply(int replyId);
}

class ReactionApiServiceImpl extends ReactionApiService {
  @override
  Future<Either<Failure, dynamic>> deleteReactReply(int replyId) async {
    try {
      var response = await sl<DioClient>()
          .delete(ApiUrl.urlReplyReaction(replyId).toString());

      if (response == "") {
        return right(null);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteReactReview(int reviewId) async {
    try {
      var response = await sl<DioClient>()
          .delete(ApiUrl.urlReviewReaction(reviewId).toString());

      if (response == "") {
        return right(null);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteReactRoute(int routeId) async {
    try {
      var response = await sl<DioClient>()
          .delete(ApiUrl.urlRouteReaction(routeId).toString());

      if (response == "") {
        return right(null);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getReactReply(int replyId) async {
    try {
      var response = await sl<DioClient>()
          .get(ApiUrl.urlReplyReaction(replyId).toString());

      if (response.statusCode == 200) {
        return right(response.data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getReactReview(int reviewId) async {
    try {
      var response = await sl<DioClient>()
          .get(ApiUrl.urlReviewReaction(reviewId).toString());

      if (response.statusCode == 200) {
        return right(response.data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getReactRoute(int routeId) async {
    try {
      var response = await sl<DioClient>()
          .get(ApiUrl.urlRouteReaction(routeId).toString());

      if (response.statusCode == 200) {
        return right(response.data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> postReactReply(int replyId) async {
    try {
      var response = await sl<DioClient>()
          .post(ApiUrl.urlReplyReaction(replyId).toString());

      if (response.statusCode == 201) {
        return right(response.data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> postReactReview(int reviewId) async {
    try {
      var response = await sl<DioClient>()
          .post(ApiUrl.urlReviewReaction(reviewId).toString());

      if (response.statusCode == 201) {
        return right(response.data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> postReactRoute(int routeId) async {
    try {
      var response = await sl<DioClient>()
          .post(ApiUrl.urlRouteReaction(routeId).toString());

      if (response.statusCode == 201) {
        return right(response.data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }
}
