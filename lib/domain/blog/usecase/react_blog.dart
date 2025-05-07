import 'package:dartz/dartz.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/blog/models/request/react_blog_req.dart';
import 'package:Tracio/domain/blog/repositories/blog_repository.dart';

import '../../../core/erorr/failure.dart';
import '../../../service_locator.dart';

class ReactBlogUseCase extends Usecase<bool, ReactBlogReq> {
  @override
  Future<Either<Failure, bool>> call(ReactBlogReq? params) async {
    return await sl<BlogRepository>().reactBlogs(params!);
  }
}
