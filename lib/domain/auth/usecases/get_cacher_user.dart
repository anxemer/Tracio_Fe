import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/auth/entities/user.dart';

class GetCacherUser implements Usecase<UserEntity, dynamic> {
  @override
  Future<Either<Failure, UserEntity>> call(params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
