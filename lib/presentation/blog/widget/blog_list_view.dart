import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/blog/blog_holder.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/presentation/auth/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/blog/models/request/get_blog_req.dart';
import '../../blog/bloc/get_blog_cubit.dart';
import '../../blog/bloc/get_blog_state.dart';
import '../../blog/widget/new_feed.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({super.key});

  @override
  State<BlogListView> createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<GetBlogCubit>();
      cubit.getBlog(GetBlogReq(isSeen: false));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<GetBlogCubit, GetBlogState>(
      builder: (context, state) {
        if (state is GetBlogLoaded) {
          if (state.blogs.isEmpty && state.metaData.isSeen!) {
            context.read<GetBlogCubit>().getBlog(GetBlogReq(isSeen: true));

            // return RefreshIndicator(
            //   onRefresh: () async {
            //     await context
            //         .read<GetBlogCubit>()
            //         .getBlog(GetBlogReq(isSeen: true));
            //   },
            //   child: ListView(
            //     physics: const AlwaysScrollableScrollPhysics(),
            //     children: const [
            //       Padding(
            //         padding: EdgeInsets.symmetric(vertical: 100.0),
            //         child: Center(
            //           child: Text(
            //               'You have viewed the entire blog, Pull to refresh'),
            //         ),
            //       ),
            //     ],
            //   ),
            // );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await context
                  .read<GetBlogCubit>()
                  .getBlog(GetBlogReq(isSeen: true));
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent * 0.7 &&
                    !(state.isLoading) &&
                    state.metaData.hasNextPage!) {
                  context.read<GetBlogCubit>().getMoreBlogs();
                }
                return false;
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.blogs.length + (state.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.blogs.length && state.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
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
                      isPersonal: true,
                      key: ValueKey('blog_${state.blogs[index].blogId}'),
                      blogs: state.blogs[index],
                    ),
                  );
                },
              ),
            ),
          );
        } else if (state is GetBlogLoading) {
          return SingleChildScrollView(child: BlogHolder());
        } else if (state is GetBlogFailure) {
          if (state.failure is AuthenticationFailure) {
            Future.microtask(
              () {
                AppNavigator.push(context, LoginPage());
              },
            );
          }
        } else {
          return SingleChildScrollView(
              child: Center(child: Text('Cannot load blog')));
        }
        return SizedBox.shrink();
      },
    );
  }
}
