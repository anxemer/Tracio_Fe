import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/widget/button/text_button.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/blog/entites/blog_entity.dart';
import 'package:Tracio/domain/blog/usecase/bookmark_blog.dart';
import 'package:Tracio/domain/blog/usecase/unBookmark.dart';
import 'package:Tracio/presentation/library/bloc/reaction/bloc/reaction_bloc.dart';

import '../../../common/helper/notification/notification_model.dart';
import '../../../core/services/signalR/implement/notification_hub_service.dart';
import '../../../service_locator.dart';

class ReactBlog extends StatefulWidget {
  ReactBlog(
      {super.key,
      required this.blogEntity,
      required this.textReactionAction,
      required this.cmtAction});
  BlogEntity blogEntity;
  final VoidCallback textReactionAction;
  final VoidCallback cmtAction;

  // bool isReaction;

  @override
  State<ReactBlog> createState() => _ReactBlogState();
}

class _ReactBlogState extends State<ReactBlog> {
  bool togleIsReaction(bool isReaction) {
    return !isReaction;
  }

  late int likesCount;
  late int commentsCount;
  late bool isReacted;
  late bool isBookmarked;
  final _notiService = sl<NotificationHubService>();
  late final StreamSubscription<NotificationModel> _messageSubscription;

  @override
  void initState() {
    likesCount = widget.blogEntity.likesCount;
    commentsCount = widget.blogEntity.commentsCount;
    isReacted = widget.blogEntity.isReacted;
    isBookmarked = widget.blogEntity.isBookmarked;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        print('ReactBlog not mounted, skipping initialization');
        return;
      }
      Future.microtask(() async {
        try {
          await _notiService.connect();
          if (!mounted) {
            return;
          }
          _messageSubscription = _notiService.onMessageUpdate.listen((message) {
            if (message.entityType == 0 && mounted) {
              setState(() {
                commentsCount++;
              });
            }
            if (message.entityType == 5 && mounted) {
              setState(() {
                likesCount++;
              });
            }
          });
        } catch (e) {
          print('Error in ReactBlog initState: $e');
        }
      });

      context
          .read<ReactionBloc>()
          .add(InitializeReactionBlog(blog: widget.blogEntity));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  BlocBuilder<ReactionBloc, ReactionState>(
                    builder: (context, state) {
                      state.reactBlog.contains(widget.blogEntity.blogId);
                      return GestureDetector(
                          onTap: () async {
                            if (widget.blogEntity.isReacted) {
                              context.read<ReactionBloc>().add(UnReactBlog(
                                  blogId: widget.blogEntity.blogId));
                              bool isReact =
                                  togleIsReaction(widget.blogEntity.isReacted);

                              setState(() {
                                widget.blogEntity.isReacted = isReact;
                                if (widget.blogEntity.likesCount > 0) {
                                  widget.blogEntity.likesCount--;
                                }
                              });
                            } else {
                              context.read<ReactionBloc>().add(ReactionBlog(
                                  blogId: widget.blogEntity.blogId));
                              bool isReact =
                                  togleIsReaction(widget.blogEntity.isReacted);

                              setState(() {
                                widget.blogEntity.isReacted = isReact;
                                widget.blogEntity.likesCount++;
                              });
                            }
                            // if (widget.blogEntity.isReacted == true) {
                            //   await sl<UnReactBlogUseCase>().call(
                            //       UnReactionParam(
                            //           id: widget.blogEntity.blogId,
                            //           type: 'blog'));
                            //   setState(() {
                            //     // if (widget.blogEntity.likesCount > 0) {
                            //     widget.blogEntity.likesCount--;
                            //     // }

                            //     widget.blogEntity.isReacted = false;
                            //     // widget.blogEntity. = 0;
                            //   });
                            // } else {
                            //   var result = await sl<ReactBlogUseCase>().call(
                            //       ReactBlogReq(
                            //           entityId: widget.blogEntity.blogId,
                            //           entityType: "blog"));
                            //   result.fold((error) {
                            //     error;
                            //   }, (data) {
                            //     bool isReact = toogleIsReaction(
                            //         widget.blogEntity.isReacted);
                            //     // context.read<ReactBlogCubit>().reactBlog(isReact);

                            //     setState(() {
                            //       widget.blogEntity.likesCount++;
                            //       // widget.blogEntity.reactionId = data.reactionId!;
                            //       widget.blogEntity.isReacted = isReact;
                            //     });
                            //   });
                            // }
                          },
                          child: Icon(
                            widget.blogEntity.isReacted
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: widget.blogEntity.isReacted
                                ? Colors.red
                                : context.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                            size: AppSize.iconSmall,
                          ));
                    },
                  ),
                  // SizedBox(
                  //   width: 2.w,
                  // ),
                  BasicTextButton(
                      text: widget.blogEntity.likesCount.toString(),
                      onPress: widget.textReactionAction),
                ],
              ),
              SizedBox(
                width: 6.w,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.cmtAction,
                    child: Icon(
                      Icons.comment_outlined,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                      size: AppSize.iconSmall,
                    ),
                  ),
                  // SizedBox(
                  //   width: 2.w,
                  // ),
                  BasicTextButton(
                      text: widget.blogEntity.commentsCount.toString(),
                      onPress: widget.cmtAction),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
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
                      bool isBookmark =
                          togleIsReaction(widget.blogEntity.isBookmarked);

                      setState(() {
                        widget.blogEntity.isBookmarked = isBookmark;
                      });
                    });
                  }
                },
                child: Icon(
                  widget.blogEntity.isBookmarked
                      ? Icons.bookmark_added_rounded
                      : Icons.bookmark_border,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                  size: AppSize.iconSmall,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
