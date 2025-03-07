import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';
import 'package:tracio_fe/service_locator.dart';

import '../../../data/blog/models/request/reply_comment_req.dart';

class RepCommentUsecase extends Usecase<bool, ReplyCommentReq> {
  @override
  Future<Either<Failure, bool>> call(ReplyCommentReq? params) async {
    return await sl<BlogRepository>().repCommentBlog(params!);
  }
}
