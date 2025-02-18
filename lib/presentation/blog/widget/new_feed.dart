import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/presentation/blog/widget/post_blog.dart';
import 'package:tracio_fe/data/blog/models/get_blog_req.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_cubit.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../bloc/get_blog_state.dart';

class NewFeeds extends StatelessWidget {
  const NewFeeds({super.key});
  // final GetBlogReq getBlogReq;

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, designSize: Size(720, 1600));
    return BlocBuilder<GetBlogCubit, GetBlogState>(
      builder: (context, state) {
        if (state is GetBlogLoading) {
          return SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        }
        if (state is GetBlogLoaded) {
          return SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => PostBlog(
                        blogEntity: state.listBlog[index],
                        // morewdget: _comment(),
                      ),
                  childCount: state.listBlog.length));
        }
        return Container();
      },
    );
  }
}
