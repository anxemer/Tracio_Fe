import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/blog/models/request/create_blog_req.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class CreateBlogUseCase extends Usecase<bool, CreateBlogReq> {
  @override
  Future<Either<Failure, bool>> call(CreateBlogReq? params) async {
    return await sl<BlogRepository>().createBlogs(params!);
  }
}
