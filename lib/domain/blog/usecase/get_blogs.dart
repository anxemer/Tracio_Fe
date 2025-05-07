import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/blog/models/request/get_blog_req.dart';
import 'package:Tracio/data/blog/models/response/blog_response.dart';
import 'package:Tracio/domain/blog/entites/blog_entity.dart';
import 'package:Tracio/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class GetBlogsUseCase extends Usecase<BlogResponse, GetBlogReq> {
  @override
  Future<Either<Failure, BlogResponse>> call(GetBlogReq? params) async {
    return await sl<BlogRepository>().getBlogs(params!);
  }
}
