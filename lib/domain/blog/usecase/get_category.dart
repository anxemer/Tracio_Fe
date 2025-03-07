import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/blog/entites/category_blog.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class GetCategoryUseCase extends Usecase<List<CategoryBlogEntity>, dynamic> {
  @override
  Future<Either<Failure,List<CategoryBlogEntity>>> call(params) async {
    return await sl<BlogRepository>().getCategoryBlog();
  }
}
