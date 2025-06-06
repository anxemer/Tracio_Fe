import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/blog/models/request/get_reply_comment_req.dart';
import 'package:Tracio/domain/blog/entites/reply_comment.dart';
import 'package:Tracio/domain/blog/repositories/blog_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetReplyCommentUsecase
    extends Usecase<ReplyCommentBlogPaginationEntity, GetReplyCommentReq> {
  @override
  Future<Either<Failure, ReplyCommentBlogPaginationEntity>> call(
      GetReplyCommentReq? params) async {
    return await sl<BlogRepository>().getRepCommentBlog(params!);
  }
}
