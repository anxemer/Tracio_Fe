import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/blog/models/request/get_blog_req.dart';
import '../../blog/bloc/get_blog_cubit.dart';
import '../../blog/bloc/get_blog_state.dart';
import '../../blog/widget/new_feed.dart';

class BlogTab extends StatefulWidget {
  const BlogTab({super.key, required this.userId});
  final int userId;

  @override
  State<BlogTab> createState() => _BlogTabState();
}

class _BlogTabState extends State<BlogTab> with AutomaticKeepAliveClientMixin {
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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<GetBlogCubit>();
      cubit.getBlog(GetBlogReq(userId: widget.userId.toString()));
    });
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
        print('Building BlogTab with state: ${state.runtimeType}');
        if (state is GetBlogLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              print('Refreshing blogs for userId: ${widget.userId}');
              await context
                  .read<GetBlogCubit>()
                  .getBlog(GetBlogReq(userId: widget.userId.toString()));
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
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
        } else {
          return const Center(child: Text('Can not load blog'));
        }
      },
    );
  }
}
