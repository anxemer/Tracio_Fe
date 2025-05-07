import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/blog/models/request/create_blog_req.dart';
import 'package:Tracio/domain/blog/entites/blog_entity.dart';
import 'package:Tracio/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class CreateBlogUseCase extends Usecase<bool, CreateBlogReq> {
  @override
  Future<Either<Failure, bool>> call(CreateBlogReq? params) async {
    return await sl<BlogRepository>().createBlogs(params!);
  }
}
