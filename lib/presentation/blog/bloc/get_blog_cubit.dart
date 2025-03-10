import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/domain/blog/entites/pagination_meta_data_entity.dart';
import 'package:tracio_fe/domain/blog/usecase/get_blogs.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_state.dart';

import '../../../data/blog/models/request/get_blog_req.dart';
import '../../../service_locator.dart';

class GetBlogCubit extends Cubit<GetBlogState> {
  GetBlogCubit()
      : super(GetBlogInitial(
          blogs: [],
          metaData: PaginationMetaDataEntity(
              pageNumber: 1, pageSize: 2, totalBlogs: 0, totalPages: 0),
          params: GetBlogReq(pageNumber: 1, pageSize: 2),
        ));

  Future<void> getBlog(GetBlogReq param) async {
    emit(GetBlogLoading(
        blogs: [],
        metaData: state.metaData,
        params: GetBlogReq(pageNumber: 1, pageSize: 2),
        isLoading: true));

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
          params: GetBlogReq(pageNumber: 1, pageSize: 2),
          metaData: data.paginationMetaDataEntity));
    });
  }

  Future<void> getMoreBlogs() async {
    final currentState = state;

    if (currentState is GetBlogLoaded &&
        currentState.isLoading == false &&
        currentState.blogs!.length < currentState.metaData.totalBlogs!) {
      try {
        emit(GetBlogLoaded(
          blogs: currentState.blogs,
          metaData: currentState.metaData,
          params: currentState.params,
          isLoading: true,
        ));

        final nextPage = currentState.metaData.pageNumber! + 1;
        final result = await sl<GetBlogsUseCase>().call(GetBlogReq(
            pageNumber: nextPage, pageSize: currentState.params.pageSize));

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
              params: GetBlogReq(
                  pageNumber: nextPage, pageSize: currentState.params.pageSize),
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
}
