import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';

abstract class ReactionRepository {
  Future<Either<Failure, dynamic>> postReplyReaction(int replyId);
  Future<Either<Failure, dynamic>> getReplyReaction(int replyId);
  Future<Either<Failure, dynamic>> deleteReplyReaction(int replyId);

  Future<Either<Failure, dynamic>> postRouteReaction(int routeId);
  Future<Either<Failure, dynamic>> getRouteReaction(int routeId);
  Future<Either<Failure, dynamic>> deleteRouteReaction(int routeId);

  Future<Either<Failure, dynamic>> postReviewReaction(int reviewId);
  Future<Either<Failure, dynamic>> getReviewReaction(int reviewId);
  Future<Either<Failure, dynamic>> deleteReviewReaction(int reviewId);
}
