import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/blog/models/create_blog_req.dart';
import 'package:tracio_fe/data/blog/models/get_blog_req.dart';
import 'package:tracio_fe/data/blog/models/react_blog_req.dart';

abstract class BlogRepository {
  Future<Either> getBlogs();
  Future<Either> reactBlogs(ReactBlogReq react);
  Future<Either> createBlogs(CreateBlogReq react);
  Future<Either> getCategoryBlog();
  Future<Either> unReactBlog(int reactId);
}
