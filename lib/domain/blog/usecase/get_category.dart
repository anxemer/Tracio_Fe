import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/blog/entites/category.dart';
import 'package:Tracio/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class GetCategoryUseCase extends Usecase<List<CategoryEntity>, dynamic> {
  @override
  Future<Either<Failure, List<CategoryEntity>>> call(params) async {
    return await sl<BlogRepository>().getCategoryBlog();
  }
}
