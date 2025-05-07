// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:Tracio/data/blog/models/request/get_blog_req.dart';
import 'package:Tracio/domain/blog/entites/blog_entity.dart';
import 'package:Tracio/domain/blog/entites/pagination_meta_data_entity.dart';

import '../../../core/erorr/failure.dart';

abstract class GetBlogState extends Equatable {
  final List<BlogEntity>? blogs;
  final PaginationMetaDataEntity metaData;
  final GetBlogReq params;
  final Failure? failure;
  final bool? isLoading;
  GetBlogState({
    required this.blogs,
    required this.metaData,
    required this.params,
    this.failure,
    this.isLoading,
  });
}

class GetBlogInitial extends GetBlogState {
  GetBlogInitial(
      {required super.blogs, required super.metaData, required super.params});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetBlogLoading extends GetBlogState {
  GetBlogLoading(
      {required super.blogs,
      required super.metaData,
      required super.params,
      required super.isLoading});

  @override
  List<Object?> get props => [];
}

class GetBlogLoaded extends GetBlogState {
  // final List<BlogEntity> listBlog;

  GetBlogLoaded(
      {required super.blogs,
      required super.metaData,
      required super.params,
      required super.isLoading});

  @override
  // TODO: implement props
  List<Object?> get props => [blogs];
}
class GetBlogBookmarkLoaded extends GetBlogState {
  // final List<BlogEntity> listBlog;

  GetBlogBookmarkLoaded(
      {required super.blogs,
      required super.metaData,
      required super.params,
      required super.isLoading});

  @override
  // TODO: implement props
  List<Object?> get props => [blogs];
}

class GetBlogFailure extends GetBlogState {
  final String errorMessage;

  GetBlogFailure(
      {required this.errorMessage,
      required super.blogs,
      required super.metaData,
      required super.params,
      required super.isLoading});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
