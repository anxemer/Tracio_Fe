import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/blog/models/request/get_blog_req.dart';
import '../../blog/bloc/get_blog_cubit.dart';
import '../../blog/bloc/get_blog_state.dart';
import '../../blog/widget/new_feed.dart';

class BookmarkBlogTab extends StatefulWidget {
  const BookmarkBlogTab(
      {super.key, required this.scrollController});
  final ScrollController scrollController;
  @override
  State<BookmarkBlogTab> createState() => _BookmarkBlogTabState();
}

class _BookmarkBlogTabState extends State<BookmarkBlogTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBlogCubit, GetBlogState>(
      builder: (context, state) {
        if (state is GetBlogLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<GetBlogCubit>().getBookmarkBlog(GetBlogReq());
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: widget.scrollController,
              itemCount: state.blogs!.length,
              itemBuilder: (context, index) {
                // if (index == state.blogs!.length && state.isLoading!) {
                //   return const Padding(
                //     padding: EdgeInsets.symmetric(vertical: 16.0),
                //     child: Center(child: CircularProgressIndicator()),
                //   );
                // }

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
          // GetBlogInitial or other states
          return const Center(child: Text('Lỗi nè'));
        }
      },
    );
  }
}
