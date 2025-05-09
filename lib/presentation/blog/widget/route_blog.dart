import 'dart:async';
import 'package:Tracio/presentation/library/widgets/route_blog_item.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/widget/blog/blog_holder.dart';

class RouteBLog extends StatefulWidget {
  const RouteBLog({super.key});

  @override
  State<RouteBLog> createState() => _RouteBLogState();
}

class _RouteBLogState extends State<RouteBLog>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Timer? _scrollDebounce;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  @override
  initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollDebounce?.isActive ?? false) _scrollDebounce!.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 200), () {
      final state = context.read<RouteCubit>().state;
      if (state is GetRouteBlogLoaded && state.hasNextPage && !_isLoadingMore) {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300) {
          _loadMore();
        }
      }
    });
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);

    final state = context.read<RouteCubit>().state;
    if (state is GetRouteBlogLoaded) {
      final nextPage = state.pageNumber + 1;

      await context.read<RouteCubit>().getRouteBlogList(
            pageNumber: nextPage,
            pageSize: state.pageSize,
          );
    }

    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollDebounce?.cancel();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<RouteCubit>().getRouteBlogList();
  }

  Widget _buildEmptyOrErrorUI(String message) {
    return SizedBox(
      // height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
        child: BlocBuilder<RouteCubit, RouteState>(
          builder: (context, state) {
            if (state is GetRouteBlogLoading || state is GetRouteInitial) {
              return BlogHolder();
            }

            if (state is GetRouteFailure) {
              return _buildEmptyOrErrorUI(
                  'Failed to load Route. Pull down to refresh.');
            }

            if (state is GetRouteBlogLoaded) {
              final routes = state.routeBlogs;

              if (routes.isEmpty) {
                return _buildEmptyOrErrorUI(
                    'No routes yet. Pull down to reload.');
              }

              return ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: routes.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < routes.length) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                            width: 4,
                          ),
                        ),
                      ),
                      child: RouteBlogItem(
                        route: routes[index],
                        routeId: routes[index].routeId,
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
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
