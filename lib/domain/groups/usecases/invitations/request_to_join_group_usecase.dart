import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/groups/repositories/invitation_repository.dart';
import 'package:Tracio/service_locator.dart';

class RequestToJoinGroupUsecase extends Usecase<dynamic, int> {
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await sl<InvitationRepository>().requestToJoinGroup(params);
  }
}
