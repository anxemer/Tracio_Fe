import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/blog/models/request/get_blog_req.dart';
import '../../blog/bloc/get_blog_cubit.dart';
import '../../blog/bloc/get_blog_state.dart';
import '../../blog/widget/new_feed.dart';

class BookmarkBlogTab extends StatefulWidget {
  const BookmarkBlogTab({super.key});

  @override
  State<BookmarkBlogTab> createState() => _BookmarkBlogTabState();
}

class _BookmarkBlogTabState extends State<BookmarkBlogTab>
    with AutomaticKeepAliveClientMixin {
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
        if (blogState is GetBlogBookmarkLoaded && !blogState.isLoading!) {
          context.read<GetBlogCubit>().getMoreBookmarkBlogs();
        }
      });
    }
  }

  void _fetchBookmarkBlogs() {
    final cubit = context.read<GetBlogCubit>();
    cubit.getBookmarkBlog(GetBlogReq(pageSize: 2, pageNumber: 1));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    _fetchBookmarkBlogs();
  }

  @override
  void didUpdateWidget(covariant BookmarkBlogTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Gọi lại khi tab được kích hoạt lại
    final currentState = context.read<GetBlogCubit>().state;
    if (currentState is GetBlogLoaded) {
      _fetchBookmarkBlogs();
    }
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<GetBlogCubit, GetBlogState>(
      builder: (context, state) {
        if (state is GetBlogBookmarkLoaded) {
          if (state.blogs!.isEmpty) {
            return const Center(child: Text('Havent Blog Bookmark Yet'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<GetBlogCubit>().getBookmarkBlog(GetBlogReq(
                    pageSize: 2,
                    pageNumber: 1,
                  ));
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: scrollController,
              itemCount:
                  state.blogs!.length + (state.isLoading ?? false ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.blogs!.length && state.isLoading!) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (index < state.blogs!.length) {
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
                      key: ValueKey('blog_${state.blogs![index].blogId}'),
                      blogs: state.blogs![index],
                    ),
                  );
                }
                return null;
              },
            ),
          );
        } else if (state is GetBlogLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetBlogFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Lỗi tải danh sách bài viết đã lưu: ${state.errorMessage}'),
                ElevatedButton(
                  onPressed: () {
                    print('Retrying fetch bookmark blogs');
                    context.read<GetBlogCubit>().getBookmarkBlog(GetBlogReq(
                          pageSize: 2,
                          pageNumber: 1,
                        ));
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Không thể tải danh sách bài viết đã lưu'),
                ElevatedButton(
                  onPressed: () {
                    print('Retrying fetch bookmark blogs');
                    context.read<GetBlogCubit>().getBookmarkBlog(GetBlogReq(
                          pageSize: 2,
                          pageNumber: 1,
                        ));
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
