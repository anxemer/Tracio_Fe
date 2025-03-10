import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/blog/header_information.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/data/blog/models/request/get_blog_req.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/presentation/auth/bloc/authCubit/auth_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:tracio_fe/presentation/blog/pages/create_blog.dart';
import 'package:tracio_fe/presentation/blog/widget/post_blog.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../common/widget/appbar/app_bar.dart';
import '../../auth/pages/login.dart';
import '../bloc/get_blog_state.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key, required this.scrollController}) : super(key: key);
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
      appBar: _buildAppBar(),
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

  PreferredSizeWidget _buildAppBar() {
    return BasicAppbar(
      centralTitle: true,
      height: 100.h,
      hideBack: true,
      title: Text(
        'Home',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 40.sp,
        ),
      ),
      action: _buildActionIcons(),
    );
  }

  Widget _buildActionIcons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Image.asset(
            AppImages.noti,
            width: 40.w,
            cacheWidth: (40 * MediaQuery.of(context).devicePixelRatio).toInt(),
          ),
          SizedBox(width: 20.w),
          Image.asset(
            AppImages.messenger,
            width: 40.w,
            cacheWidth: (40 * MediaQuery.of(context).devicePixelRatio).toInt(),
          ),
          SizedBox(width: 20.w),
          GestureDetector(
            onTap: () async {
              context.read<AuthCubit>().logout();
              AppNavigator.pushReplacement(context, LoginPage());
            },
            child: Image.asset(
              AppImages.search,
              width: 40.w,
              cacheWidth:
                  (40 * MediaQuery.of(context).devicePixelRatio).toInt(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createBlogHeader() {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, const CreateBlogPage());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          width: double.infinity,
          height: 100.h,
          child: HeaderInformation(
            title: const Text(
              'An Xểm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Share your picture'),
            imageUrl: Image.asset(
              AppImages.man,
              cacheWidth:
                  (100 * MediaQuery.of(context).devicePixelRatio).toInt(),
            ),
            trailling: Icon(
              Icons.image_outlined,
              size: 40.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(GetBlogState state) {
    if (state is GetBlogLoaded) {
      return _BlogListView(
        blogs: state.blogs!,
        isLoading: state.isLoading!,
      );
    } else if (state is GetBlogLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      // GetBlogInitial or other states
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: SizedBox(),
      );
    }
  }
}

// Tách danh sách blog thành một StatelessWidget riêng để tránh rebuild khi parent thay đổi
class _BlogListView extends StatelessWidget {
  const _BlogListView({
    Key? key,
    required this.blogs,
    required this.isLoading,
  }) : super(key: key);

  final List<BlogEntity> blogs;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == blogs.length && isLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (index < blogs.length) {
            return PostBlog(
              key: ValueKey('blog_${blogs[index].blogId}'),
              blogEntity: blogs[index],
            );
          }

          return null;
        },
        childCount: blogs.length + (isLoading ? 1 : 0),
      ),
    );
  }
}
