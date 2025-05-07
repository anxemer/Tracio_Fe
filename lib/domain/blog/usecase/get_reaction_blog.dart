import 'package:dartz/dartz.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/blog/models/request/react_blog_req.dart';
import 'package:Tracio/domain/blog/entites/reaction_response_entity.dart';
import 'package:Tracio/domain/blog/repositories/blog_repository.dart';

import '../../../core/erorr/failure.dart';
import '../../../service_locator.dart';

class GetReactBlogUseCase extends Usecase<List<ReactionResponseEntity>, int> {
  @override
  Future<Either<Failure, List<ReactionResponseEntity>>> call(
      int? params) async {
    return await sl<BlogRepository>().getReactBlogs(params!);
  }
}
