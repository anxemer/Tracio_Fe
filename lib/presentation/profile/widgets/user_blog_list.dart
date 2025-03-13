import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:tracio_fe/presentation/blog/widget/new_feed.dart';

import '../../../common/widget/appbar/app_bar.dart';
import '../../../common/widget/button/floating_button.dart';
import '../../blog/bloc/get_blog_state.dart';

class UserBlogList extends StatefulWidget {
  const UserBlogList({super.key, required this.userId});
  final int userId;

  @override
  State<UserBlogList> createState() => _UserBlogListState();
}

class _UserBlogListState extends State<UserBlogList> {
  late ScrollController scrollController;

  Timer? _scrollDebounce;
  void _scrollListener() {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;
    double scrollPercentage = 0.7;

    if (currentScroll > (maxScroll * scrollPercentage)) {
      if (_scrollDebounce?.isActive ?? false) _scrollDebounce!.cancel();

      _scrollDebounce = Timer(const Duration(milliseconds: 500), () {
        final blogState = context.read<GetBlogCubit>().state;
        if (blogState is GetBlogLoaded && blogState.isLoading == false) {
          context.read<GetBlogCubit>().getMoreBlogs();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  // final List<BlogEntity> blogs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppbar(
            height: 100.h,
            hideBack: false,
            title: Text(
              'Profile',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 40.sp),
            ),
            action: Row(
              children: [
                // FloatingButton(
                //   elevation: 0,
                //   backgroundColor: Colors.transparent,
                //   onPressed: () {},
                //   action: Icon(
                //     Icons.more_vert_outlined,
                //     color: Colors.black,
                //   ),
                // ),
              ],
            )),
        body: BlocBuilder<GetBlogCubit, GetBlogState>(
          builder: (context, state) {
            if (state is GetBlogLoaded) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: scrollController,
                itemCount: state.blogs!.length + (state.isLoading! ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.blogs!.length && state.isLoading!) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (index < state.blogs!.length) {
                    return NewFeeds(
                      blogs: state.blogs![index],
                    );
                  }
                  return null;
                },
              );
            } else if (state is GetBlogLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              // GetBlogInitial or other states
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
