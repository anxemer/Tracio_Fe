import 'package:Tracio/domain/blog/entites/comment_blog.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/blog/models/request/comment_blog_req.dart';
import 'package:Tracio/domain/blog/repositories/blog_repository.dart';
import 'package:Tracio/service_locator.dart';

class CommentBlogUsecase extends Usecase<CommentBlogEntity, CommentBlogReq> {
  @override
  Future<Either<Failure, CommentBlogEntity>> call(CommentBlogReq? params) async {
    return await sl<BlogRepository>().commentBlog(params!);
  }
}
