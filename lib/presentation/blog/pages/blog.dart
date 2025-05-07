import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/data/blog/models/request/get_blog_req.dart';
import 'package:Tracio/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:Tracio/presentation/blog/widget/blog_list_view.dart';
import 'package:Tracio/presentation/blog/widget/create_blog_header.dart';
import 'package:Tracio/presentation/blog/widget/shortcut_key.dart';
import 'package:Tracio/presentation/blog/widget/snapshot_home.dart';

import '../bloc/get_blog_state.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll > maxScroll * 0.7 && _tabController.index == 0) {
      final blogState = context.read<GetBlogCubit>().state;
      if (blogState is GetBlogLoaded && !blogState.isLoading!) {
        context.read<GetBlogCubit>().getMoreBlogs();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              toolbarHeight: 60.h,
              flexibleSpace: CreateBlogHeader(),
            ),
            SliverToBoxAdapter(
              child:
                  Divider(thickness: 4, height: 4, color: Colors.grey.shade300),
            ),
            SliverAppBar(
              toolbarHeight: 120.h,
              flexibleSpace: WeeklySnapshotCard(
                totalDistance: 100,
                totalDuration: 500,
                totalElevationGain: 10,
                totalRides: 10,
                distanceUnit: 'KM',
              ),
            ),
            SliverToBoxAdapter(
              child:
                  Divider(thickness: 4, height: 4, color: Colors.grey.shade300),
            ),
            SliverAppBar(
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
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              // Tab 1: Blogs
              BlocProvider(
                create: (_) =>
                    GetBlogCubit()..getBlog(GetBlogReq()),
                child: const BlogListView(),
              ),
              // Tab 2: Routes
              Container(),
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
