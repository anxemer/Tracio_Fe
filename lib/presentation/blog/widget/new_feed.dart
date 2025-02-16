import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/blog/post_blog.dart';
import 'package:tracio_fe/data/blog/models/get_blog_req.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_cubit.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../bloc/get_blog_state.dart';

class NewFeeds extends StatelessWidget {
  final ScrollController scrollController;
  const NewFeeds({super.key, required this.scrollController});
  // final GetBlogReq getBlogReq;

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, designSize: Size(720, 1600));
    return BlocProvider(
      create: (context) => GetBlogCubit()..getBlog(),
      child: BlocBuilder<GetBlogCubit, GetBlogState>(
        builder: (context, state) {
          if (state is GetBlogLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetBlogLoaded) {
            return CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => PostBlog(
                              blogEntity: state.listBlog[index],
                              // morewdget: _comment(),
                            ),
                        childCount: state.listBlog.length)),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _comment() {
    return //Comments
        Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Row(
        children: [
          Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(60.sp)),
            width: 80.w,
            // height: 100.h,
            child: Image.asset(
              AppImages.man,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            // height: MediaQuery.of(context).size.height,

            child: TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  hintText: 'Add a comment',
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 15)),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Icon(
            Icons.send_rounded,
            color: AppColors.background,
            size: 30,
          )
        ],
      ),
    );
  }
}
