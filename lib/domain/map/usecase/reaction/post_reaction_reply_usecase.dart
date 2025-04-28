import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/map/repositories/reaction_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class PostReactionReplyUsecase extends Usecase<dynamic, int> {
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await sl<ReactionRepository>().postReplyReaction(params);
  }
}
