import 'package:Tracio/data/blog/models/request/get_blog_req.dart';
import 'package:Tracio/presentation/blog/bloc/comment/get_comment_cubit.dart';
import 'package:Tracio/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:Tracio/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/presentation/profile/widgets/blog_tab.dart';
import 'package:Tracio/presentation/profile/widgets/bookmark_blog.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../common/widget/appbar/app_bar.dart';

class UserBlogList extends StatefulWidget {
  const UserBlogList({super.key, required this.userId, required this.userName});
  final int userId;
  final String userName;

  @override
  State<UserBlogList> createState() => _UserBlogListState();
}

class _UserBlogListState extends State<UserBlogList> {
  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return GetBookingCubit();
          },
        ),
        BlocProvider(
          create: (context) {
            return GetCommentCubit();
          },
        ),
      ],
      child: Scaffold(
        appBar: BasicAppbar(
          centralTitle: true,
          height: 100.h,
          hideBack: false,
          title: Text(
            widget.userName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSize.textHeading.sp,
              color: Colors.white,
            ),
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
          ),
        ),
        body: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            children: [
              TabBar(
                padding: EdgeInsets.only(left: 0),
                labelStyle: TextStyle(
                  fontSize: AppSize.textMedium,
                  fontWeight: FontWeight.w600,
                ),
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
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    BlocProvider(
                      create: (context) => GetBlogCubit()
                        ..getBlog(GetBlogReq(userId: widget.userId.toString())),
                      child: BlogTab(userId: widget.userId),
                    ),
                    BlocProvider(
                      create: (context) => GetBlogCubit()
                        ..getBookmarkBlog(
                            GetBlogReq(userId: widget.userId.toString())),
                      child: BookmarkBlogTab(
                        userId: widget.userId,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
