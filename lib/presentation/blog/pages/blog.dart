import 'dart:async';

import 'package:Tracio/common/bloc/generic_data_cubit.dart';
import 'package:Tracio/common/widget/button/loading.dart';
import 'package:Tracio/presentation/blog/widget/route_blog.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:Tracio/presentation/blog/widget/blog_list_view.dart';
import 'package:Tracio/presentation/blog/widget/create_blog_header.dart';
import 'package:Tracio/presentation/blog/widget/shortcut_key.dart';
import 'package:Tracio/presentation/blog/widget/snapshot_home.dart';

import '../../../common/bloc/generic_data_state.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _tabController = TabController(length: 2, vsync: this);
    // _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  late ScrollController _scrollController;
  Timer? _scrollDebounce;

  // void _scrollListener() {
  //   double maxScroll = _scrollController.position.maxScrollExtent;
  //   double currentScroll = _scrollController.position.pixels;
  //   double scrollPercentage = 0.7;

  //   if (currentScroll > (maxScroll * scrollPercentage)) {
  //     if (_scrollDebounce?.isActive ?? false) _scrollDebounce!.cancel();

  //     _scrollDebounce = Timer(const Duration(milliseconds: 500), () {
  //       final blogState = context.read<GetBlogCubit>().state;
  //       if (blogState is GetBlogLoaded &&
  //           blogState.isLoading == false &&
  //           blogState.metaData.hasNextPage!) {
  //         print(blogState.metaData.hasNextPage!);
  //         context.read<GetBlogCubit>().getMoreBlogs();
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 60.h,
              flexibleSpace: CreateBlogHeader(),
            ),
            SliverToBoxAdapter(
              child:
                  Divider(thickness: 4, height: 4, color: Colors.grey.shade300),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 120.h,
              flexibleSpace: BlocBuilder<GenericDataCubit, GenericDataState>(
                builder: (context, state) {
                  if (state is DataLoaded) {
                    return WeeklySnapshotCard(
                      activity: state.data,
                    );
                  }
                  if (state is DataLoading) {
                    return LoadingButton();
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            SliverToBoxAdapter(
              child:
                  Divider(thickness: 4, height: 4, color: Colors.grey.shade300),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 80.h,
              flexibleSpace: ShortcutKey(),
            ),
            SliverPersistentHeader(
              
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Blogs"),
                    Tab(text: "Routes"),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            // physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              // Tab 1: Blogs
              BlocProvider(
                create: (_) => GetBlogCubit(),
                child: const BlogListView(),
              ),
              // Tab 2: Routes
              BlocProvider(
                create: (context) => RouteCubit()..getRouteBlogList(),
                child: RouteBLog(scrollController: _scrollController),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
