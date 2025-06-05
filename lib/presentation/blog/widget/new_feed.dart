import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/blog/entites/blog_entity.dart';
import 'package:Tracio/presentation/blog/bloc/comment/comment_input_cubit.dart';
import 'package:Tracio/presentation/blog/widget/post_blog.dart';
import 'package:Tracio/presentation/blog/widget/react_blog.dart';
import '../../../common/bloc/generic_data_cubit.dart';
import '../../../common/widget/blog/custom_bottomsheet.dart';
import '../../../domain/blog/entites/reaction_response_entity.dart';
import '../../../domain/blog/usecase/get_reaction_blog.dart';
import '../../../service_locator.dart';
import '../bloc/comment/get_comment_cubit.dart';
import 'comment.dart';
import 'list_react.dart';

class NewFeeds extends StatelessWidget {
  const NewFeeds({super.key, required this.blogs, this.isPersonal = false});

  final BlogEntity blogs;
  final bool isPersonal;
  @override
  Widget build(BuildContext context) {
    final commentCubit = context.read<GetCommentCubit>();
    return Column(
      children: [
        PostBlog(
          isPersonal: isPersonal,
          blogEntity: blogs,
          //  onLikeUpdated: () => blogs.likesCount++,
          // morewdget: _comment(),
        ),
        const SizedBox(height: 10),
        ReactBlog(
          blogEntity: blogs,
          textReactionAction: () => CustomModalBottomSheet.show(
              context: context,
              child: BlocProvider(
                create: (context) => GenericDataCubit()
                  ..getData<List<ReactionResponseEntity>>(
                      sl<GetReactBlogUseCase>(),
                      params: blogs.blogId),
                child: ListReact(
                  blogId: blogs.blogId,

                  //             ),
                ),
              )),
          cmtAction: () => CustomModalBottomSheet.show(
            context: context,
            child: BlocProvider(
              create: (context) => CommentInputCubit.forBlog(blogs.blogId),
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
