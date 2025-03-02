import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/data/blog/models/request/comment_blog_req.dart';
import 'package:tracio_fe/domain/blog/usecase/comment_blog.dart';
import 'package:tracio_fe/presentation/blog/widget/comment_item.dart';
import 'package:tracio_fe/service_locator.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../data/blog/models/request/get_comment_req.dart';
import '../bloc/comment/get_comment_state.dart';
import '../bloc/comment/get_commnet_cubit.dart';

class Comment extends StatefulWidget {
  final int blogId;
  final GetCommentCubit cubit;

  const Comment({super.key, required this.blogId, required this.cubit});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  TextEditingController _titleCon = TextEditingController();
  @override
  void initState() {
    super.initState();
    print("Comment initState called for blogId: ${widget.blogId}");
    widget.cubit.getCommentBlog(GetCommentReq(
        blogId: widget.blogId,
        ascending: true,
        commentId: 0,
        pageNumber: 1,
        pageSize: 5));
  }

  @override
  void dispose() {
    _titleCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCommentCubit, GetCommentState>(
      bloc: widget.cubit,
      builder: (context, state) {
        print("Comment state: ${state.runtimeType}");
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // Thanh kéo
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Container(
                    width: 200.w,
                    height: 3.h,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Comments',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 32.sp),
                ),
                // Nội dung chính (danh sách bình luận hoặc thông báo)
                Expanded(
                  child: _buildContent(state),
                ),
                // Trường nhập liệu luôn hiển thị
                _comment(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(GetCommentState state) {
    if (state is GetCommentLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is GetCommentFailure) {
      return const Center(child: Text("Chưa có bình luận"));
    }
    if (state is GetCommentLoaded) {
      final comments = state.listComment ?? [];
      print("Comments length: ${comments.length}");
      return comments.isEmpty
          ? const Center(child: Text("Chưa có bình luận"))
          : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
                  child: CommentItem(comment: comments[index]),
                );
              },
            );
    }
    return const Center(child: Text("Chưa có bình luận"));
  }

  Widget _comment() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.sp),
            border: Border.all(color: Colors.black45, width: 3.w)),
        child: Row(
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 10.w)),
            ClipOval(
              child: SizedBox(
                width: 80.w,
                height: 80.h,
                child: Image.asset(AppImages.man),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: TextField(
                controller: _titleCon,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Add a comment',
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
                onTap: () async {
                  var result =
                      await sl<CommentBlogUsecase>().call(CommentBlogReq(
                    blogId: widget.blogId,
                    content: _titleCon.text,
                  ));

                  result.fold((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gửi bình luận thất bại')),
                    );
                  }, (susscess) {
                    widget.cubit.getCommentBlog(GetCommentReq(
                      blogId: widget.blogId,
                      ascending: true,
                      commentId: 0,
                      pageNumber: 1,
                      pageSize: 5,
                    ));
                    _titleCon.clear();
                  });
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Icon(Icons.send_rounded,
                    color: AppColors.background, size: 30)),
          ],
        ),
      ),
    );
  }
}
