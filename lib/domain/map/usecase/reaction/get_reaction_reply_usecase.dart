import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/map/repositories/reaction_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetReactionReplyUsecase extends Usecase<dynamic, int> {
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await sl<ReactionRepository>().getReplyReaction(params);
  }
}
