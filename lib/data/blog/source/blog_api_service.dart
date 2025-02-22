import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/blog/models/create_blog_req.dart';
import 'package:tracio_fe/data/blog/models/react_blog_req.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class BlogApiService {
  Future<Either> getBlogs();
  Future<Either> reactBlog(ReactBlogReq react);
  Future<Either> createBlog(CreateBlogReq react);
  Future<Either> getCategoryBlog();
  Future<Either> unReactBlog(int reactId);
  Future<Either> getReactBlog(int reactId);
}

class BlogApiServiceImpl extends BlogApiService {
  @override
  Future<Either> getBlogs() async {
    try {
      Uri apiUrl = ApiUrl.urlGetBlog({});
      var response = await sl<DioClient>().get(apiUrl.toString());
      return right(response.data);
    } on DioException catch (e) {
      return left(e.response!.data['result']['message']);
    }
  }

  @override
  Future<Either> reactBlog(ReactBlogReq react) async {
    try {
      var response = await sl<DioClient>().post(ApiUrl.reactBlog, data: react);
      return right(response.data);
    } on DioException catch (e) {
      return left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> createBlog(CreateBlogReq request) async {
    try {
      FormData formData = await request.toFormData();
      var response = await sl<DioClient>()
          .post(isMultipart: true, ApiUrl.createBlog, data: formData);
      if (response.statusCode == 201) {
        return right(response.data);
      }
      return left(response.data['message']);
    } on DioException catch (e) {
      return left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> getCategoryBlog() async {
    try {
      var response = await sl<DioClient>().get(ApiUrl.categoryBlog);
      if (response.statusCode == 200) {
        return right(response.data);
      }
      return left(response.data['message']);
    } on DioException catch (e) {
      return left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> unReactBlog(int reactId) async {
    try {
      var response =
          await sl<DioClient>().delete('${ApiUrl.unReactBlog}/$reactId');

      if (response.data['status'] == 204) {
        return right(response.data);
      }
      return left(response.data);
    } on DioException catch (e) {
      return left(e.response!.data['title']);
    }
  }

  @override
  Future<Either> getReactBlog(int reactId) async {
    // TODO: implement getReactBlog
    throw UnimplementedError();
  }
}
