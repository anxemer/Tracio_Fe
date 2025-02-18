import 'package:tracio_fe/domain/blog/entites/blog.dart';

abstract class GetBlogState {}

class GetBlogLoading extends GetBlogState {}

class GetBlogLoaded extends GetBlogState {
  final List<BlogEntity> listBlog;

  GetBlogLoaded({required this.listBlog});
}

class GetBlogFailure extends GetBlogState {
  final String errorMessage;

  GetBlogFailure({required this.errorMessage});
}
