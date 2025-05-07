import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/map/source/reaction_api_service.dart';
import 'package:Tracio/domain/map/repositories/reaction_repository.dart';
import 'package:Tracio/service_locator.dart';

class ReactionRepositoryImpl extends ReactionRepository {
  @override
  Future<Either<Failure, dynamic>> deleteReplyReaction(int replyId) async {
    var returnedData = await sl<ReactionApiService>().deleteReactReply(replyId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> deleteReviewReaction(int reviewId) async {
    var returnedData =
        await sl<ReactionApiService>().deleteReactReview(reviewId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> deleteRouteReaction(int routeId) async {
    var returnedData = await sl<ReactionApiService>().deleteReactRoute(routeId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> getReplyReaction(int replyId) async {
    var returnedData = await sl<ReactionApiService>().getReactReply(replyId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> getReviewReaction(int reviewId) async {
    var returnedData = await sl<ReactionApiService>().getReactReview(reviewId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> getRouteReaction(int routeId) async {
    var returnedData = await sl<ReactionApiService>().getReactRoute(routeId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> postReplyReaction(int replyId) async {
    var returnedData = await sl<ReactionApiService>().postReactReply(replyId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> postReviewReaction(int reviewId) async {
    var returnedData = await sl<ReactionApiService>().postReactReview(reviewId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> postRouteReaction(int routeId) async {
    var returnedData = await sl<ReactionApiService>().postReactRoute(routeId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }
}
