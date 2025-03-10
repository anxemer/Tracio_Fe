import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/blog/models/request/comment_blog_req.dart';
import 'package:tracio_fe/domain/blog/entites/comment_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/comment_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/get_comment_blog.dart';
import 'package:tracio_fe/presentation/blog/bloc/comment/comment_state.dart';

import '../../../../core/signalr_service.dart';
import '../../../../data/blog/models/request/get_comment_req.dart';
import '../../../../service_locator.dart';

class CommentCubit extends Cubit<CommentState> {
  StreamSubscription? _joinedBlogUpdateSubscription;
  final SignalRService  signalRService;
  final int blogId;
  CommentCubit({required this.signalRService, required this.blogId})
      : super(CommentState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      emit(state.copyWith(isLoading: true));

      // 1. Kết nối SignalR
      await signalRService.connect();

      // 2. Tham gia nhóm BlogUpdates
      await signalRService.joinBlogUpdates();

      // 3. Lắng nghe sự kiện đã tham gia thành công
      _setupJoinedListener();

      await loadComments();

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Initialization error: ${e.toString()}',
      ));
    }
  }

  void _setupJoinedListener() {
    _joinedBlogUpdateSubscription = signalRService.joinedBlogUpdate.listen(
      (joinedBlogId) {
        print('Successfully joined BlogUpdates with ID: $joinedBlogId');
        loadComments();
      },
    );
  }

  // // Thiết lập timer để refresh comments theo định kỳ
  // void _setupRefreshTimer() {
  //   // Hủy timer cũ nếu có
  //   _refreshTimer?.cancel();

  //   // Thiết lập timer mới (ví dụ: mỗi 5 giây)
  //   _refreshTimer = Timer.periodic(Duration(seconds: 5), (_) {
  //     loadComments();
  //   });
  // }

  Future<void> loadComments() async {
    try {
      final comments = await sl<GetCommentBlogUseCase>().call(GetCommentReq(
        blogId: blogId,
        ascending: true,
        commentId: 0,
        pageNumber: 1,
        pageSize: 10,
      ));
      comments.fold((error) {
        error.message;
      }, (data) {
        emit(state.copyWith(
          comments: data,
          commentCount: data.length,
        ));
      });
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load comments: ${e.toString()}'));
    }
  }

  // // Thêm comment mới
  Future<void> addComment(String content) async {
    try {
      // final comment = CommentBlogEntity(
      //   blogId: blogId,
      //   content: content,
      //   authorName: 'Current User', // Thông tin user thực tế
      //   createdAt: DateTime.now(),
      // );

      // // Gửi comment đến API
      // await _repository.addComment(comment);
      var reuslt = await sl<CommentBlogUsecase>()
          .call(CommentBlogReq(blogId: blogId, content: content));
      // Sau khi thêm comment thành công, load lại comments ngay lập tức
      reuslt.fold((error) {
        ExceptionFailure(error.message);
      }, (data) async {
        await loadComments();
      });
    } catch (e) {
      emit(state.copyWith(error: 'Failed to add comment: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _joinedBlogUpdateSubscription?.cancel();
    // _refreshTimer?.cancel();
    return super.close();
  }
}
