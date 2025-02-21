import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/blog/models/blog.dart';
import 'package:tracio_fe/data/blog/models/category_blog.dart';
import 'package:tracio_fe/data/blog/models/create_blog_req.dart';
import 'package:tracio_fe/data/blog/models/react_blog_req.dart';
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
          .map((item) => BlogModels.fromJson(item).toEntity())
          .toList();
      return right(blogs);
    });
  }

  @override
  Future<Either> reactBlogs(ReactBlogReq react) async {
    var returnedData = await sl<BlogApiService>().reactBlog(react);
    return returnedData.fold((error) {
      return left(false);
    }, (data) {
      return right(true);
    });
  }

  @override
  Future<Either> createBlogs(CreateBlogReq react) async {
    var returnData = await sl<BlogApiService>().createBlog(react);
    return returnData.fold((erorr) {
      return left(erorr);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either> getCategoryBlog() async {
    var returnData = await sl<BlogApiService>().getCategoryBlog();
    return returnData.fold((error) {
      return left(error);
    }, (data) {
      var categories = List.from(data['result']['categories'])
          .map((e) => CategoryBlogModel.fromMap(e).toEntity())
          .toList();
      return right(categories);
    });
  }

  @override
  Future<Either> unReactBlog(int reactId) async {
    var returnData = await sl<BlogApiService>().unReactBlog(reactId);
    return returnData.fold((error) {
      return left(false);
    }, (data) {
      return right(true);
    });
  }
}
