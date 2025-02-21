import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/blog/models/create_blog_req.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class CreateBlogUseCase extends Usecase<Either, CreateBlogReq> {
  @override
  Future<Either> call({CreateBlogReq? params}) async {
    return await sl<BlogRepository>().createBlogs(params!);
  }
}
