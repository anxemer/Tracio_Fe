import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../repositories/blog_repository.dart';

class UnReactBlogUseCase extends Usecase<dynamic, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<BlogRepository>().unReactBlog(params!);
  }
}
