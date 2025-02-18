import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/blog/models/react_blog_req.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class ReactBlogUseCase extends Usecase<Either, ReactBlogReq> {
  @override
  Future<Either> call({ReactBlogReq? params}) async {
    return await sl<BlogRepository>().reactBlogs(params!);
  }
}
