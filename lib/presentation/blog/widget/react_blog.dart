import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/bloc/generic_data_cubit.dart';
import 'package:tracio_fe/common/widget/button/text_button.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/domain/blog/entites/reaction_response_entity.dart';
import 'package:tracio_fe/domain/blog/usecase/bookmark_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/get_reaction_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/unBookmark.dart';
import 'package:tracio_fe/presentation/blog/widget/comment.dart';
import 'package:tracio_fe/presentation/blog/widget/icon_blog.dart';
import 'package:tracio_fe/presentation/blog/widget/list_react.dart';

import '../../../data/blog/models/request/react_blog_req.dart';
import '../../../domain/blog/usecase/react_blog.dart';
import '../../../domain/blog/usecase/un_react_blog.dart';
import '../../../service_locator.dart';
import '../bloc/comment/get_commnet_cubit.dart';

class ReactBlog extends StatefulWidget {
  ReactBlog({super.key, required this.blogEntity});
  BlogEntity blogEntity;
  // bool isReaction;

  @override
  State<ReactBlog> createState() => _ReactBlogState();
}

class _ReactBlogState extends State<ReactBlog> {
  bool toogleIsReaction(bool isReaction) {
    return !isReaction;
  }

  @override
  Widget build(BuildContext context) {
    final commentCubit = context.read<GetCommentCubit>();
    final reacCubit = context.read<GenericDataCubit>();

    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.w,
              ),
              Row(
                children: [
                  GestureDetector(
                      onTap: () async {
                        if (widget.blogEntity.isReacted == true) {
                          await sl<UnReactBlogUseCase>().call(UnReactionParam(
                              id: widget.blogEntity.blogId, type: 'blog'));
                          setState(() {
                            if (widget.blogEntity.likesCount > 0) {
                              widget.blogEntity.likesCount--;
                            }

                            widget.blogEntity.isReacted = false;
                            // widget.blogEntity. = 0;
                          });
                        } else {
                          var result = await sl<ReactBlogUseCase>().call(
                              ReactBlogReq(
                                  entityId: widget.blogEntity.blogId,
                                  entityType: "blog"));
                          result.fold((error) {
                            error;
                          }, (data) {
                            bool isReact =
                                toogleIsReaction(widget.blogEntity.isReacted);
                            // context.read<ReactBlogCubit>().reactBlog(isReact);

                            setState(() {
                              widget.blogEntity.likesCount++;
                              // widget.blogEntity.reactionId = data.reactionId!;
                              widget.blogEntity.isReacted = isReact;
                            });
                          });
                        }
                      },
                      child: Icon(
                        widget.blogEntity.isReacted
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: widget.blogEntity.isReacted
                            ? Colors.red
                            : Colors.black,
                        size: 44.sp,
                      )),
                  SizedBox(
                    width: 10.w,
                  ),
                  BasicTextButton(
                      text: widget.blogEntity.likesCount.toString(),
                      onPress: () {
                        showModalBottomSheet(
                            isDismissible: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: DraggableScrollableSheet(
                                    maxChildSize: 1,
                                    initialChildSize: .5,
                                    minChildSize: 0.2,
                                    builder: (context, scrollController) =>
                                        ListReact(
                                      blogId: widget.blogEntity.blogId,
                                      cubit: reacCubit,
                                    ),
                                  ),
                                ),
                              );
                            });
                      }),
                ],
              ),
              SizedBox(
                width: 20.w,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => showModalBottomSheet(
                        isDismissible: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: DraggableScrollableSheet(
                              maxChildSize: 1,
                              initialChildSize: .8,
                              minChildSize: 0.2,
                              builder: (context, scrollController) => Comment(
                                blogId: widget.blogEntity.blogId,
                                cubit: commentCubit,
                              ),
                            ),
                          );
                        }),
                    child: Icon(
                      Icons.comment_outlined,
                      color: Colors.black,
                      size: 44.sp,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  BasicTextButton(
                      text: widget.blogEntity.commentsCount.toString(),
                      onPress: () {
                        showModalBottomSheet(
                            isDismissible: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: DraggableScrollableSheet(
                                  maxChildSize: .8,
                                  initialChildSize: .8,
                                  minChildSize: 0.2,
                                  builder: (context, scrollController) =>
                                      Comment(
                                    blogId: widget.blogEntity.blogId,
                                    cubit: commentCubit,
                                  ),
                                ),
                              );
                            });
                      }),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  print('đã bấm');
                  if (widget.blogEntity.isBookmarked == true) {
                    await sl<UnBookmarkUseCase>()
                        .call(widget.blogEntity.blogId);
                    setState(() {
                      widget.blogEntity.isBookmarked = false;
                      // widget.blogEntity. = 0;
                    });
                  } else {
                    var result = await sl<BookmarkBlogUseCase>()
                        .call(widget.blogEntity.blogId);
                    result.fold((error) {
                      error;
                    }, (data) {
                      bool isReact =
                          toogleIsReaction(widget.blogEntity.isBookmarked);

                      setState(() {
                        widget.blogEntity.isBookmarked = isReact;
                      });
                    });
                  }
                },
                child: Icon(
                  widget.blogEntity.isBookmarked
                      ? Icons.bookmark_added_rounded
                      : Icons.bookmark_border,
                  color: Colors.black,
                  size: 44.sp,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
