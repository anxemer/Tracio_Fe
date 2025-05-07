import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/widget/blog/blog_holder.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:Tracio/presentation/blog/widget/new_feed.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../data/blog/models/request/get_blog_req.dart';
import '../bloc/get_blog_state.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({super.key});

  @override
  State<BlogListView> createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Timer? _scrollDebounce;

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<GetBlogCubit>().getBlog(GetBlogReq(isSeen: true));
  }

  Widget _buildEmptyOrErrorUI(String message) {
    return SizedBox(
      // height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.error,
              width: AppSize.imageLarge,
            ),
            SizedBox(height: 16.h),
            Text(message),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: BlocBuilder<GetBlogCubit, GetBlogState>(
          builder: (context, state) {
            if (state is GetBlogLoading || state is GetBlogInitial) {
              return BlogHolder();
            }

            if (state is GetBlogFailure) {
              return _buildEmptyOrErrorUI(
                  'Failed to load blogs. Pull down to refresh.');
            }

            if (state is GetBlogLoaded) {
              final blogs = state.blogs ?? [];

              if (blogs.isEmpty) {
                return _buildEmptyOrErrorUI(
                    'No blogs yet. Pull down to reload.');
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: blogs.length + (state.isLoading! ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == blogs.length && state.isLoading!) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSize.apSectionPadding.w,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (index < blogs.length) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                            width: 4,
                          ),
                        ),
                      ),
                      child: NewFeeds(
                        key: ValueKey('blog_${blogs[index].blogId}'),
                        blogs: blogs[index],
                      ),
                    );
                  }

                  return null;
                },
              );
            }

            return _buildEmptyOrErrorUI('No blogs yet. Pull down to refresh.');
          },
        ),
      ),
    );
  }
}
