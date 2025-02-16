import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/blog/models/blog.dart';
import 'package:tracio_fe/data/blog/models/get_blog_req.dart';
import 'package:tracio_fe/data/blog/source/blog_api_service.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';

import '../../../service_locator.dart';

class BlogRepositoryImpl extends BlogRepository {
  @override
  Future<Either> getBlogs() async {
    var returnedData = await sl<BlogApiService>().getBlogs();
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      var blogs = List.from(data['result']['blogs'])
          .map((item) => BlogModels.fromMap(item).toEntity())
          .toList();
      return right(blogs);
    });
  }
}
