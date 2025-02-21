import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/button/text_button.dart';
import 'package:tracio_fe/domain/blog/entites/blog.dart';
import 'package:tracio_fe/presentation/blog/bloc/react_blog_cubit.dart';
import 'package:tracio_fe/presentation/blog/widget/comment.dart';
import 'package:tracio_fe/presentation/blog/widget/list_react.dart';

import '../../../data/blog/models/react_blog_req.dart';
import '../../../domain/blog/usecase/react_blog.dart';
import '../../../domain/blog/usecase/un_react_blog.dart';
import '../../../service_locator.dart';

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
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () async {
                      print(widget.blogEntity.isReacted);
                      // final cubit = context.read<ReactBlogCubit>();
                      if (widget.blogEntity.isReacted) {
                        var result = await sl<UnReactBlogUseCase>()
                            .call(params: widget.blogEntity.reactionId);
                        result.fold((error) {
                          error;
                        }, (data) {
                          bool isReact =
                              toogleIsReaction(widget.blogEntity.isReacted);
                          print('data$data');
                          // context.read<ReactBlogCubit>().reactBlog(isReact);
                          print(isReact);
                          setState(() {
                            widget.blogEntity.isReacted = isReact;
                          });
                        });
                      } else {
                        var result = await sl<ReactBlogUseCase>().call(
                            params: ReactBlogReq(
                                entityId: widget.blogEntity.blogId,
                                entityType: "blog"));
                        result.fold((error) {
                          error;
                        }, (data) {
                          bool isReact =
                              toogleIsReaction(widget.blogEntity.isReacted);
                          // context.read<ReactBlogCubit>().reactBlog(isReact);
                          print(isReact);

                          setState(() {
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
                      size: 52.sp,
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
                                      ListReact(),
                                ),
                              ),
                            );
                          });
                    }),
                // Text(
                //   widget.blogEntity.likesCount.toString(),
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 28.sp,
                //       color: Colors.black),
                // )
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
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: DraggableScrollableSheet(
                            maxChildSize: 1,
                            initialChildSize: .5,
                            minChildSize: 0.2,
                            builder: (context, scrollController) => Comment(),
                          ),
                        );
                      }),
                  child: Icon(
                    Icons.comment_outlined,
                    color: Colors.black,
                    size: 52.sp,
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
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: DraggableScrollableSheet(
                                maxChildSize: .5,
                                initialChildSize: .5,
                                minChildSize: 0.2,
                                builder: (context, scrollController) =>
                                    Comment(),
                              ),
                            );
                          });
                    }),
                // Text(
                //   widget.blogEntity.commentsCount.toString(),
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 28.sp,
                //       color: Colors.black),
                // )
              ],
            ),
            // SizedBox(
            //   width: 20.w,
            // ),

            // SizedBox(
            //   width: 400.w,
            // ),
            Spacer(),
            Icon(
              Icons.bookmark_border,
              color: Colors.black,
              size: 52.sp,
            ),
          ],
        )
      ],
    );
  }
}
