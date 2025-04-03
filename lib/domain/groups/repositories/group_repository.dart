import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/groups/models/request/post_group_req.dart';

abstract class GroupRepository {
  Future<Either<Failure, dynamic>> postGroup(PostGroupReq request);
}
