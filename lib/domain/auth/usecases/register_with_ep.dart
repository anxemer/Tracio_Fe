import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/auth/models/register_req.dart';
import 'package:Tracio/domain/auth/repositories/auth_repository.dart';

import '../../../service_locator.dart';

class RegisterWithEmailAndPassUseCase extends Usecase<bool, RegisterReq> {
  @override
  Future<Either<Failure, bool>> call(RegisterReq? params) async {
    return await sl<AuthRepository>().registerWithEmailAndPassword(params!);
  }
}
