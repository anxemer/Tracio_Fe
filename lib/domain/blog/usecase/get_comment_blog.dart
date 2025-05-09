import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/blog/models/request/get_comment_req.dart';
import 'package:Tracio/domain/blog/entites/comment_blog.dart';
import 'package:Tracio/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class GetCommentBlogUseCase
    extends Usecase<CommentBlogPaginationEntity, GetCommentReq> {
  @override
  Future<Either<Failure, CommentBlogPaginationEntity>> call(
      GetCommentReq? params) async {
    return await sl<BlogRepository>().getCommentBlog(params!);
  }
}
