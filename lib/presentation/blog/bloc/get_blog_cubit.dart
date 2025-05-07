import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/domain/blog/entites/blog_entity.dart';
import 'package:Tracio/domain/blog/entites/pagination_meta_data_entity.dart';
import 'package:Tracio/domain/blog/usecase/get_blogs.dart';
import 'package:Tracio/domain/blog/usecase/get_bookmark_blog.dart';
import 'package:Tracio/presentation/blog/bloc/get_blog_state.dart';

import '../../../data/blog/models/request/get_blog_req.dart';
import '../../../service_locator.dart';

class GetBlogCubit extends Cubit<GetBlogState> {
  GetBlogCubit()
      : super(GetBlogInitial(
          blogs: [],
          metaData: PaginationMetaDataEntity(),
          params: GetBlogReq(pageSize: 2, pageNumber: 1),
        ));

  Future<void> getBlog(GetBlogReq param) async {
    try {
      emit(GetBlogLoading(
          blogs: [], metaData: state.metaData, params: param, isLoading: true));

      var returnedData = await sl<GetBlogsUseCase>().call(state.params);

      returnedData.fold((error) {
        emit(GetBlogFailure(
            blogs: state.blogs,
            errorMessage: error.message,
            isLoading: false,
            metaData: state.metaData,
            params: state.params));
      }, (data) {
        emit(GetBlogLoaded(
            blogs: data.blogs,
            isLoading: false,
            params: state.params,
            metaData: data.paginationMetaDataEntity));
      });
    } catch (e) {
      emit(GetBlogFailure(
          blogs: state.blogs,
          errorMessage: e.toString(),
          isLoading: false,
          metaData: state.metaData,
          params: state.params));
    }
  }

  Future<void> getBookmarkBlog(GetBlogReq param) async {
    try {
      emit(GetBlogLoading(
          blogs: [], metaData: state.metaData, params: param, isLoading: true));

      var returnedData = await sl<GetBookmarkBlogsUseCase>().call(state.params);

      returnedData.fold((error) {
        emit(GetBlogFailure(
            blogs: state.blogs,
            errorMessage: error.message,
            isLoading: false,
            metaData: state.metaData,
            params: state.params));
      }, (data) {
        emit(GetBlogLoaded(
            blogs: data.blogs,
            isLoading: false,
            params: state.params,
            metaData: data.paginationMetaDataEntity));
      });
    } catch (e) {
      emit(GetBlogFailure(
          blogs: state.blogs,
          errorMessage: e.toString(),
          isLoading: false,
          metaData: state.metaData,
          params: state.params));
    }
  }

  Future<void> getMoreBlogs() async {
    final currentState = state;

    if (currentState is GetBlogLoaded && currentState.isLoading == false) {
      try {
        emit(GetBlogLoaded(
          blogs: currentState.blogs,
          metaData: currentState.metaData,
          params: currentState.params,
          isLoading: true,
        ));

        final nextPage = currentState.metaData.pageNumber! + 1;
        final result = await sl<GetBlogsUseCase>().call(
            GetBlogReq(pageNumber: nextPage, isSeen: state.metaData.isSeen));

        result.fold((error) {
          emit(GetBlogFailure(
              errorMessage: error.message,
              blogs: currentState.blogs,
              metaData: currentState.metaData,
              params: currentState.params,
              isLoading: false));
        }, (data) {
          final updatedBlogs = List<BlogEntity>.from(currentState.blogs!);
          updatedBlogs.addAll(data.blogs);
          emit(GetBlogLoaded(
              blogs: updatedBlogs,
              metaData: data.paginationMetaDataEntity,
              params: GetBlogReq(),
              isLoading: false));
        });
      } catch (e) {
        if (currentState is GetBlogLoaded) {
          emit(GetBlogLoaded(
              blogs: currentState.blogs,
              metaData: currentState.metaData,
              params: currentState.params,
              isLoading: false));
        }
        debugPrint("Error in getMoreBlogs: $e");
      }
    }
  }

  Future<void> getMoreBookmarkBlogs() async {
    final currentState = state;

    if (currentState is GetBlogLoaded && currentState.isLoading == false) {
      try {
        emit(GetBlogLoaded(
          blogs: currentState.blogs,
          metaData: currentState.metaData,
          params: currentState.params,
          isLoading: true,
        ));

        final nextPage = currentState.metaData.pageNumber! + 1;
        final result = await sl<GetBookmarkBlogsUseCase>().call(
            GetBlogReq(pageNumber: nextPage, isSeen: state.metaData.isSeen));

        result.fold((error) {
          emit(GetBlogFailure(
              errorMessage: error.message,
              blogs: currentState.blogs,
              metaData: currentState.metaData,
              params: currentState.params,
              isLoading: false));
        }, (data) {
          final updatedBlogs = List<BlogEntity>.from(currentState.blogs!);
          updatedBlogs.addAll(data.blogs);
          emit(GetBlogLoaded(
              blogs: updatedBlogs,
              metaData: data.paginationMetaDataEntity,
              params: GetBlogReq(),
              isLoading: false));
        });
      } catch (e) {
        if (currentState is GetBlogLoaded) {
          emit(GetBlogLoaded(
              blogs: currentState.blogs,
              metaData: currentState.metaData,
              params: currentState.params,
              isLoading: false));
        }
        debugPrint("Error in getMoreBlogs: $e");
      }
    }
  }

  void incrementCommentCount(int blogId) {
    if (state is GetBlogLoaded) {
      final currentState = state as GetBlogLoaded;
      final updatedBlogs = currentState.blogs!.map((blog) {
        if (blog.blogId == blogId) {
          return blog.copyWith(commentsCount: blog.commentsCount + 1);
        }
        return blog;
      }).toList();
      emit(GetBlogLoaded(
        blogs: updatedBlogs,
        isLoading: false,
        params: currentState.params,
        metaData: currentState.metaData,
      ));
    }
  }
}
