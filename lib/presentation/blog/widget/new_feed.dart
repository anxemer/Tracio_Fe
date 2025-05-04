import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/presentation/blog/bloc/comment/comment_input_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/comment/comment_input_state.dart';
import 'package:tracio_fe/presentation/blog/widget/post_blog.dart';
import 'package:tracio_fe/presentation/blog/widget/react_blog.dart';
import '../../../common/bloc/generic_data_cubit.dart';
import '../../../common/widget/blog/custom_bottomsheet.dart';
import '../bloc/comment/get_comment_cubit.dart';
import 'comment.dart';
import 'list_react.dart';

class NewFeeds extends StatelessWidget {
  const NewFeeds({super.key, required this.blogs, this.isPersonal = false});
  // final GetBlogReq getBlogReq;
  final BlogEntity blogs;
  final bool isPersonal;
  @override
  Widget build(BuildContext context) {
    final commentCubit = context.read<GetCommentCubit>();
    final reacCubit = context.read<GenericDataCubit>();
    return Column(
      children: [
        PostBlog(
          isPersonal: isPersonal,
          blogEntity: blogs, onLikeUpdated: () => blogs.likesCount++,
          // morewdget: _comment(),
        ),
        const SizedBox(height: 10),
        ReactBlog(
          blogEntity: blogs,
          textReactionAction: () => CustomModalBottomSheet.show(
              context: context,
              child: ListReact(
                blogId: blogs.blogId,
                cubit: reacCubit,
                //             ),
              )),
          cmtAction: () => CustomModalBottomSheet.show(
            context: context,
            child: BlocProvider(
              create: (context) => CommentInputCubit(blogs.blogId),
              child: BlocProvider.value(
                value: commentCubit,
                child: Comment(
                  blogId: blogs.blogId,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSize.apSectionPadding),
      ],
    );
  }
}
