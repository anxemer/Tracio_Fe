import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';

import '../../../service_locator.dart';

class RegisterWithEmailAndPassUseCase extends Usecase<Either, RegisterReq> {
  @override
  Future<Either> call({RegisterReq? params}) async {
    return await sl<AuthRepository>().registerWithEmailAndPassword(params!);
  }
}
