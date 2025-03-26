import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/blog/entites/category.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class GetCategoryUseCase extends Usecase<List<CategoryEntity>, dynamic> {
  @override
  Future<Either<Failure, List<CategoryEntity>>> call(params) async {
    return await sl<BlogRepository>().getCategoryBlog();
  }
}
