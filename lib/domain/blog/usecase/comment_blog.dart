import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/blog/models/request/comment_blog_req.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class CommentBlogUsecase extends Usecase<bool, CommentBlogReq> {
  @override
  Future<Either<Failure, bool>> call(CommentBlogReq? params) async {
    return await sl<BlogRepository>().commentBlog(params!);
  }
}
