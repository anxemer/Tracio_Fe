import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:tracio_fe/presentation/profile/widgets/blog_tab.dart';
import 'package:tracio_fe/presentation/profile/widgets/bookmark_blog.dart';

import '../../../common/widget/appbar/app_bar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../blog/bloc/get_blog_state.dart';

class UserBlogList extends StatefulWidget {
  const UserBlogList({super.key, required this.userId, required this.userName});
  final int userId;
  final String userName;

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
    var isDark = context.isDarkMode;
    return Scaffold(
        appBar: BasicAppbar(
            centralTitle: true,
            height: 100.h,
            hideBack: false,
            title: Text(
              widget.userName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.textHeading.sp,
                  color: Colors.white),
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
        body: DefaultTabController(
            length: 2,
            initialIndex: 1,
            child: Column(
              children: [
                TabBar(
                    padding: EdgeInsets.only(left: 0),
                    labelStyle: TextStyle(
                        fontSize: AppSize.textMedium,
                        fontWeight: FontWeight.w600),
                    unselectedLabelColor:
                        isDark ? Colors.white70 : Colors.grey.shade500,
                    labelColor: isDark ? AppColors.primary : Colors.black,
                    indicatorColor: AppColors.primary,
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.photo_size_select_large_rounded,
                          size: AppSize.iconMedium,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.bookmark_added,
                          size: AppSize.iconMedium,
                        ),
                      )
                    ]),
                Expanded(
                  child: TabBarView(children: [
                    BlogTab(
                        scrollController: scrollController,
                        userId: widget.userId),
                    BookmarkBlogTab(scrollController: scrollController)
                  ]),
                )
              ],
            )));
  }
}
