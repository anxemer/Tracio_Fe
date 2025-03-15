import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              await context.read<GetBlogCubit>().getBlog(GetBlogReq());
            },
            child: CustomScrollView(
              controller: widget.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Create blog header - always shown
                SliverToBoxAdapter(
                  child: _createBlogHeader(),
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
                            UserProfilePage(userId: state.user.userId)),
                        child: SizedBox(
                          child: CirclePicture(
                              imageUrl: state.user.profilePicture!,
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
        } else if (state is AuthFailure) {
          Future.delayed(Duration.zero, () {
            if (context.mounted) {
              _showAuthFailureDialog(context);
            }
          });

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            child: Center(child: CircularProgressIndicator()),
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
                Navigator.of(context).pop();
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
      return BlogListView(
        blogs: state.blogs!,
        isLoading: state.isLoading!,
      );
    } else if (state is GetBlogLoading || state is GetBlogInitial) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (state is GetBlogFailure) {
      Future.delayed(Duration.zero, () {
        if (context.mounted) {
          _showAuthFailureDialog(context);
        }
      });
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
            child: Column(
          children: [
            Image.asset(
              AppImages.error,
              width: AppSize.imageLarge,
            ),
            Text('Can\'t load blog....'),
            IconButton(
                onPressed: () async {
                  await context.read<GetBlogCubit>().getBlog(GetBlogReq());
                },
                icon: Icon(
                  Icons.refresh_outlined,
                  size: AppSize.iconLarge,
                ))
          ],
        )),
      );
    }
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(child: Text('data')),
    );
  }
}
