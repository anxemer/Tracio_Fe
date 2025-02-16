import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/blog/models/get_blog_req.dart';

abstract class BlogRepository {
  Future<Either> getBlogs();
}
