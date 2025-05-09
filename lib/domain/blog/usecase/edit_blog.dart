import 'package:Tracio/data/blog/models/response/edit_blog_model.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class EditBlogUseCase extends Usecase<bool, EditBlogModel> {
  @override
  Future<Either<Failure, bool>> call(EditBlogModel? params) async {
    return await sl<BlogRepository>().editBlogs(params!);
  }
}
