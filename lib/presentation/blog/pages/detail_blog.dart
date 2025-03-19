import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/presentation/blog/widget/post_blog.dart';

import '../../../common/bloc/generic_data_cubit.dart';
import '../../../common/widget/appbar/app_bar.dart';
import '../../../common/widget/button/floating_button.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../bloc/comment/get_comment_cubit.dart';
import '../widget/comment.dart';
import '../widget/react_blog.dart';

class DetailBlocPage extends StatefulWidget {
  const DetailBlocPage({super.key, required this.blog});
  final BlogEntity blog;

  @override
  State<DetailBlocPage> createState() => _DetailBlocPageState();
}

class _DetailBlocPageState extends State<DetailBlocPage> {
  @override
  Widget build(BuildContext context) {
    final commentCubit = context.read<GetCommentCubit>();
    final reacCubit = context.read<GenericDataCubit>();
    return Scaffold(
        appBar: BasicAppbar(
          height: 100.h,
          hideBack: false,
          title: Text(
            'Blog',
            style: TextStyle(
                color: context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: AppSize.textLarge.sp),
          ),
          action: Row(
            children: [
              FloatingButton(
                elevation: 0,
                backgroundColor: Colors.white,
                onPressed: () {},
                action: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            PostBlog(blogEntity: widget.blog),
            ReactBlog(
                blogEntity: widget.blog,
                textReactionAction: () {},
                cmtAction: () {}),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              // width: 400.w,
              height: MediaQuery.of(context).size.height / 1.2,
              child: Comment(blogId: widget.blog.blogId, cubit: commentCubit),
            )
            // Comment(blogId: widget.blog.blogId, cubit: commentCubit)
          ],
        )));
  }
}
