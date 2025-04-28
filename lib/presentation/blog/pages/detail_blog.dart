import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/presentation/blog/pages/edit_blog.dart';
import 'package:tracio_fe/presentation/blog/widget/post_blog.dart';

import '../../../common/widget/appbar/app_bar.dart';
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
    
    Item? selectedItem;
    final commentCubit = context.read<GetCommentCubit>();
    // final reacCubit = context.read<GenericDataCubit>();
    return Scaffold(
        appBar: BasicAppbar(
          backgroundColor: AppColors.lightBackground,
          height: 100.h,
          hideBack: false,
          title: Text(
            'Blog',
            style: TextStyle(
                color:
                    context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: AppSize.textHeading.sp),
          ),
          action: PopupMenuButton<Item>(
            initialValue: selectedItem,
            onSelected: (Item item) {
              setState(() {
                selectedItem = item;
              });
              if (item == Item.edit) {
                // Chuyển sang trang Edit
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditBlogPostScreen(
                        imageUrl: widget.blog.mediaFiles,
                            blogId: widget.blog.blogId,
                            initialContent: widget.blog.content,
                            initialIsPublic: widget.blog.isPublic,
                          )),
                );
              } else if (item == Item.delete) {}
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Item>>[
              const PopupMenuItem<Item>(value: Item.edit, child: Text('Edit')),
              const PopupMenuItem<Item>(
                  value: Item.delete, child: Text('Delete')),
            ],
          ),
          // Row(
          //   children: [
          //     FloatingButton(
          //       elevation: 0,
          //       backgroundColor: Colors.white,
          //       onPressed: () {},
          //       action: Icon(
          //         Icons.more_vert,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ],
          // ),
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

enum Item { edit, delete }
