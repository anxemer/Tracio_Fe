import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/domain/blog/entites/pagination_meta_data_entity.dart';
import 'package:tracio_fe/domain/blog/usecase/get_blogs.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_state.dart';

import '../../../core/signalr_service.dart';
import '../../../data/blog/models/request/get_blog_req.dart';
import '../../../service_locator.dart';

class GetBlogCubit extends Cubit<GetBlogState> {
  final SignalRService _signalRService;
  StreamSubscription? _blogReactionSubscription;

  GetBlogCubit({SignalRService? signalRService})
      : _signalRService = signalRService ?? sl<SignalRService>(),
        super(GetBlogInitial(
          blogs: [],
          metaData: PaginationMetaDataEntity(),
          params: GetBlogReq(pageSize: 2, pageNumber: 1),
        )) {
    // Lắng nghe sự kiện SignalR khi khởi tạo
    _listenToSignalR();
  }

  // Thiết lập lắng nghe sự kiện SignalR
  void _listenToSignalR() {
    // Đảm bảo kết nối SignalR đã được khởi tạo
    if (!_signalRService.isConnected) {
      _signalRService.initConnection().then((_) {
        _signalRService.joinBlogUpdates();
        _setupblogReactionListener();
      });
    } else {
      _signalRService.joinBlogUpdates();
      _setupblogReactionListener();
    }
  }

  // Thiết lập listener cho sự kiện nhận phản ứng comment mới
  void _setupblogReactionListener() {
    _blogReactionSubscription =
        _signalRService.onReceiveNewBlogReaction.listen((data) {
      _updateBlogCommentCount(data['blogId']);
    });
  }

  void _updateBlogCommentCount(int blogId) {
    final currentState = state;

    if (currentState.blogs!.isNotEmpty) {
      // Tạo bản sao của danh sách blog hiện tại
      final updatedBlogs = List<BlogEntity>.from(currentState.blogs!);

      // Tìm vị trí blog cần cập nhật
      final blogIndex =
          updatedBlogs.indexWhere((blog) => blog.blogId == blogId);

      if (blogIndex != -1) {
        final updatedBlog = updatedBlogs[blogIndex]
            .copyWith(commentsCount: updatedBlogs[blogIndex].commentsCount + 1);

        // Cập nhật blog trong danh sách
        updatedBlogs[blogIndex] = updatedBlog;

        // Emit state mới với danh sách blog đã cập nhật
        if (currentState is GetBlogLoaded) {
          emit(GetBlogLoaded(
            blogs: updatedBlogs,
            metaData: currentState.metaData,
            params: currentState.params,
            isLoading: currentState.isLoading,
          ));
        } else if (currentState is GetBlogInitial) {
          emit(GetBlogInitial(
            blogs: updatedBlogs,
            metaData: currentState.metaData,
            params: currentState.params,
          ));
        } else if (currentState is GetBlogLoading) {
          emit(GetBlogLoading(
            blogs: updatedBlogs,
            metaData: currentState.metaData,
            params: currentState.params,
            isLoading: currentState.isLoading,
          ));
        }
      }
    }
  }

  Future<void> getBlog(GetBlogReq param) async {
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

  // Đảm bảo hủy subscription khi cubit bị đóng
  @override
  Future<void> close() {
    _blogReactionSubscription?.cancel();
    return super.close();
  }
}
