import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/presentation/blog/widget/new_feed.dart';

class BlogListView extends StatelessWidget {
  const BlogListView({
    super.key,
    required this.blogs,
    required this.isLoading,
  });

  final List<BlogEntity> blogs;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == blogs.length && isLoading) {
            return Padding(
              padding:
                  EdgeInsets.symmetric(vertical: AppSize.apSectionPadding.w),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (index < blogs.length) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[300]!,
                    width: 0.7,
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
        childCount: blogs.length + (isLoading ? 1 : 0),
      ),
    );
  }
}
