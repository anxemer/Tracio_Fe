import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/blog/repositories/blog_repository.dart';
import 'package:Tracio/service_locator.dart';

import '../../../data/blog/models/request/reply_comment_req.dart';
import '../entites/reply_comment.dart';

class RepCommentUsecase extends Usecase<ReplyCommentEntity, ReplyCommentReq> {
  @override
  Future<Either<Failure, ReplyCommentEntity>> call(
      ReplyCommentReq? params) async {
    return await sl<BlogRepository>().repCommentBlog(params!);
  }
}
