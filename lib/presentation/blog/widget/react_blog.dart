import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/button/text_button.dart';
import 'package:tracio_fe/domain/blog/entites/blog.dart';
import 'package:tracio_fe/presentation/blog/widget/comment.dart';
import 'package:tracio_fe/presentation/blog/widget/list_react.dart';

class ReactBlog extends StatefulWidget {
  const ReactBlog({super.key, required this.blogEntity});
  final BlogEntity blogEntity;

  @override
  State<ReactBlog> createState() => _ReactBlogState();
}

class _ReactBlogState extends State<ReactBlog> {
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
                Icon(
                  Icons.favorite_outline,
                  color: Colors.black,
                  size: 52.sp,
                ),
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
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: DraggableScrollableSheet(
                                maxChildSize: 1,
                                initialChildSize: .5,
                                minChildSize: 0.2,
                                builder: (context, scrollController) =>
                                    ListReact(),
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
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => Navigator.pop(context),
                            child: DraggableScrollableSheet(
                              maxChildSize: 1,
                              initialChildSize: .5,
                              minChildSize: 0.2,
                              builder: (context, scrollController) => Comment(),
                            ),
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
                      showBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => Navigator.pop(context),
                                child: DraggableScrollableSheet(
                                  maxChildSize: .5,
                                  initialChildSize: .5,
                                  minChildSize: 0.2,
                                  builder: (context, scrollController) =>
                                      Comment(),
                                ),
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
