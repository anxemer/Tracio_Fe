import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/blog/models/request/react_blog_req.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';

import '../../../core/erorr/failure.dart';
import '../../../data/blog/models/view/reaction_response_model.dart';
import '../../../service_locator.dart';

class ReactBlogUseCase extends Usecase<ReactionResponseModel, ReactBlogReq> {
  @override
  Future<Either<Failure, ReactionResponseModel>> call(
      ReactBlogReq? params) async {
    return await sl<BlogRepository>().reactBlogs(params!);
  }
}
