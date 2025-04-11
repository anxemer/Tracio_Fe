import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tracio_fe/common/widget/picture/circle_picture.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/blog/models/request/get_blog_req.dart';
import 'package:tracio_fe/presentation/auth/bloc/authCubit/auth_cubit.dart';
import 'package:tracio_fe/presentation/auth/pages/login.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:tracio_fe/presentation/blog/pages/create_blog.dart';
import 'package:tracio_fe/presentation/blog/widget/blog_list_view.dart';
import 'package:tracio_fe/presentation/blog/widget/shortcut_key.dart';
import 'package:tracio_fe/presentation/profile/pages/user_profile.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../auth/bloc/authCubit/auth_state.dart';
import '../bloc/get_blog_state.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  Timer? _scrollDebounce;
  void _scrollListener() {
    double maxScroll = widget.scrollController.position.maxScrollExtent;
    double currentScroll = widget.scrollController.position.pixels;
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
    widget.scrollController.addListener(_scrollListener);
    // context.read<GetBlogCubit>().getBlog(GetBlogReq());
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetBlogCubit, GetBlogState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.background,
            onRefresh: () async {
              await context
                  .read<GetBlogCubit>()
                  .getBlog(GetBlogReq(isSeen: true));
            },
            child: CustomScrollView(
              controller: widget.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Create blog header - always shown
                SliverToBoxAdapter(
                  child: _createBlogHeader(),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    thickness: 4,
                    height: 2,
                    color: Colors.grey.shade300,
                  ),
                ),
                SliverToBoxAdapter(
                  child: ShortcutKey(),
                ),
                // Main content based on state
                _buildMainContent(state),
              ],
            ),
          );
        },
      ),
    );
  }

  // Extracted widgets for better performance

  Widget _createBlogHeader() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoaded) {
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: 8.h, horizontal: AppSize.apHorizontalPadding.w),
            child: SizedBox(
                height: AppSize.appBarHeight.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () => AppNavigator.push(context,
                            UserProfilePage(userId: state.user!.userId)),
                        child: SizedBox(
                          child: CirclePicture(
                              imageUrl: state.user!.profilePicture!,
                              imageSize: AppSize.iconMedium),
                        )),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            AppNavigator.push(context, CreateBlogPage()),
                        child: Row(
                          children: [
                            Text(
                              'Share your picture',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppSize.textLarge.sp),
                            ),
                            Spacer(),
                            Icon(
                              Icons.image_outlined,
                              size: AppSize.iconLarge.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        }
        return Container();
      },
    );
  }

  void _showAuthFailureDialog(BuildContext context) {
    Timer(Duration(seconds: 30), () {
      Navigator.of(context).pop();
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Authentication Failed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Your session has expired. You will be redirected to the login page in 30 seconds.'),
              SizedBox(height: 16.h),
              Text('You can go back to login now if you prefer.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<AuthCubit>().logout();
                // Navigator.of(context).pop();
                AppNavigator.pushAndRemove(context, LoginPage());
              },
              child: Text('Go to Login Now'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainContent(GetBlogState state) {
    if (state is GetBlogLoaded) {
      if (state.blogs!.isEmpty) {
        return SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppImages.error,
                    width: AppSize.imageLarge,
                  ),
                  SizedBox(height: 16.h),
                  Text('No blogs yet. Pull down to refresh.'),
                ],
              ),
            ),
          ),
        );
      }
      return BlogListView(
        blogs: state.blogs!,
        isLoading: state.isLoading!,
      );
    } else if (state is GetBlogLoading || state is GetBlogInitial) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
            child: Shimmer.fromColors(
          baseColor: Colors.black26,
          highlightColor: Colors.black54,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black38,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                width: 160,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.black26,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(3, (index) {
                  return Container(
                    width: double.infinity,
                    height: 12,
                    margin: EdgeInsets.only(top: index == 0 ? 0 : 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.black26,
                    ),
                  );
                }),
              ),
              // SizedBox(
              //   height: 10.h,
              // ),
              // Row(
              //   children: [
              //     const CircleAvatar(
              //       backgroundColor: Colors.black54,
              //       child: Icon(
              //         Icons.person,
              //         color: Colors.white,
              //       ),
              //     ),
              //     SizedBox(
              //       height: 10.h,
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [120, 180].asMap().entries.map((e) {
              //         return Container(
              //           width: e.value.toDouble(),
              //           height: 12,
              //           margin: EdgeInsets.only(top: e.key == 0 ? 0 : 8),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(4),
              //             color: Colors.black26,
              //           ),
              //         );
              //       }).toList(),
              //     ),
              //   ],
              // ),
            ],
          ),
        )),
      );
    } else if (state is GetBlogFailure) {
      Future.delayed(Duration.zero, () {
        if (context.mounted) {
          _showAuthFailureDialog(context);
        }
      });
      return SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppImages.error,
                  width: AppSize.imageLarge,
                ),
                SizedBox(height: 16.h),
                Text('No blogs yet. Pull down to refresh.'),
              ],
            ),
          ),
        ),
      );
    }
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppImages.error,
                width: AppSize.imageLarge,
              ),
              SizedBox(height: 16.h),
              Text('No blogs yet. Pull down to refresh.'),
            ],
          ),
        ),
      ),
    );
  }
}
