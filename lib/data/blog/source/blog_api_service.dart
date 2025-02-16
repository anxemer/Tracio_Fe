import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/blog/models/get_blog_req.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class BlogApiService {
  Future<Either> getBlogs();
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
}
