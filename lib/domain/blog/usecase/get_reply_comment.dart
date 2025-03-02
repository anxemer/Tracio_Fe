import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/blog/models/request/comment_blog_req.dart';
import 'package:tracio_fe/data/blog/models/request/get_reply_comment_req.dart';
import 'package:tracio_fe/data/blog/models/request/reply_comment_req.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetReplyCommentUsecase
    extends Usecase<List<ReplyCommentEntity>, GetReplyCommentReq> {
  @override
  Future<Either<Failure, List<ReplyCommentEntity>>> call(
      GetReplyCommentReq? params) async {
    return await sl<BlogRepository>().getRepCommentBlog(params!);
  }
}
