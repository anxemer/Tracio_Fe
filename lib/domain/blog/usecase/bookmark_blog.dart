import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../repositories/blog_repository.dart';

class BookmarkBlogUseCase extends Usecase<bool,int>{
  @override
  Future<Either<Failure, bool>> call(int params) async{
    return await sl<BlogRepository>().bookmarkBlogs(params!);
  }
}