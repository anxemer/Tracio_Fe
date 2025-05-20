import 'package:Tracio/data/user/models/send_fcm_req.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/auth/repositories/auth_repository.dart';
import 'package:Tracio/service_locator.dart';

class SendFcmUseCase extends Usecase<bool, SendFcmReq> {
  @override
  Future<Either<Failure, bool>> call(params) async {
    return await sl<AuthRepository>().sendFcm(params);
  }
}
