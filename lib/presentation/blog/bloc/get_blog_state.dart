// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:Tracio/data/blog/models/request/get_blog_req.dart';
import 'package:Tracio/domain/blog/entites/blog_entity.dart';
import 'package:Tracio/domain/blog/entites/pagination_meta_data_entity.dart';

import '../../../core/erorr/failure.dart';

abstract class GetBlogState extends Equatable {
  final List<BlogEntity> blogs;
  final PaginationMetaDataEntity metaData;
  final GetBlogReq params;
  final Failure? failure;
  final bool isLoading;

  const GetBlogState({
    required this.blogs,
    required this.metaData,
    required this.params,
    this.failure,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [blogs, metaData, params, failure, isLoading];
}

// Initial
class GetBlogInitial extends GetBlogState {
  const GetBlogInitial({
    required super.blogs,
    required super.metaData,
    required super.params,
  });
}

// Loading
class GetBlogLoading extends GetBlogState {
  const GetBlogLoading({
    required super.blogs,
    required super.metaData,
    required super.params,
    required super.isLoading,
  });
}

// Loaded
class GetBlogLoaded extends GetBlogState {
  const GetBlogLoaded({
    required super.blogs,
    required super.metaData,
    required super.params,
    required super.isLoading,
  });

  GetBlogLoaded copyWith({
    List<BlogEntity>? blogs,
    PaginationMetaDataEntity? metaData,
    GetBlogReq? params,
    bool? isLoading,
  }) {
    return GetBlogLoaded(
      blogs: blogs ?? this.blogs,
      metaData: metaData ?? this.metaData,
      params: params ?? this.params,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Bookmark Loaded
class GetBlogBookmarkLoaded extends GetBlogState {
  const GetBlogBookmarkLoaded({
    required super.blogs,
    required super.metaData,
    required super.params,
    required super.isLoading,
  });

  GetBlogBookmarkLoaded copyWith({
    List<BlogEntity>? blogs,
    PaginationMetaDataEntity? metaData,
    GetBlogReq? params,
    bool? isLoading,
  }) {
    return GetBlogBookmarkLoaded(
      blogs: blogs ?? this.blogs,
      metaData: metaData ?? this.metaData,
      params: params ?? this.params,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Failure
class GetBlogFailure extends GetBlogState {
  final String errorMessage;

  const GetBlogFailure({
    required this.errorMessage,
    required super.blogs,
    required super.metaData,
    required super.params,
    required super.isLoading,
    super.failure,
  });

  @override
  List<Object?> get props =>
      [errorMessage, blogs, metaData, params, isLoading];
}
