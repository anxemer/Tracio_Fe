import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/blog/models/request/get_blog_req.dart';
import 'package:tracio_fe/data/blog/models/response/blog_response.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class GetBlogsUseCase extends Usecase<BlogResponse, GetBlogReq> {
  @override
  Future<Either<Failure, BlogResponse>> call(GetBlogReq? params) async {
    return await sl<BlogRepository>().getBlogs(params!);
  }
}
