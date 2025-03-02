// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../repositories/blog_repository.dart';

class UnReactBlogUseCase extends Usecase<bool, UnReactionParam> {
  @override
  Future<Either<Failure, bool>> call(UnReactionParam params) async {
    return await sl<BlogRepository>().unReactBlog(params);
  }
}

class UnReactionParam {
  final int id;
  final String type;
  UnReactionParam({
    required this.id,
    required this.type,
  });
}
