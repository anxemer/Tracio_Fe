import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/blog/models/request/get_comment_req.dart';
import 'package:tracio_fe/domain/blog/entites/comment_blog.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class GetCommentBlogUseCase
    extends Usecase<CommentBlogPaginationEntity, GetCommentReq> {
  @override
  Future<Either<Failure, CommentBlogPaginationEntity>> call(
      GetCommentReq? params) async {
    return await sl<BlogRepository>().getCommentBlog(params!);
  }
}
