import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/blog/models/get_blog_req.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class GetBlogsUseCase extends Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<BlogRepository>().getBlogs();
  }
}
