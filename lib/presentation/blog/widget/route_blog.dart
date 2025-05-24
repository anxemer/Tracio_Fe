import 'dart:async';
import 'package:Tracio/presentation/library/widgets/route_blog_item.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/widget/blog/blog_holder.dart';

import '../../../main.dart';

class RouteBLog extends StatefulWidget {
  final ScrollController scrollController;

  const RouteBLog({super.key, required this.scrollController});

  @override
  State<RouteBLog> createState() => _RouteBLogState();
}

class _RouteBLogState extends State<RouteBLog>
    with AutomaticKeepAliveClientMixin, RouteAware {
  @override
  bool get wantKeepAlive => true;
  Timer? _scrollDebounce;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<RouteCubit>().getRouteBlogList();
  }

  void _onScroll() {
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.position.pixels;

    if (currentScroll > maxScroll * 0.7) {
      if (_scrollDebounce?.isActive ?? false) _scrollDebounce!.cancel();

      _scrollDebounce = Timer(const Duration(milliseconds: 300), () {
        final state = context.read<RouteCubit>().state;
        if (state is GetRouteBlogLoaded && state.hasNextPage) {
          context.read<RouteCubit>().getRouteBlogList(
                pageNumber: state.pageNumber + 1,
                pageSize: state.pageSize,
              );
        }
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
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
            if (state is GetRouteBlogLoading ||
                state is GetRouteInitial ||
                state is GetRouteDetailLoading) {
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
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: routes.length,
                itemBuilder: (context, index) {
                  // if (index == blogs.length && state.isLoading!) {
                  //   return Padding(
                  //     padding: EdgeInsets.symmetric(
                  //       vertical: AppSize.apSectionPadding.w,
                  //     ),
                  //     child: const Center(
                  //       child: CircularProgressIndicator(),
                  //     ),
                  //   );
                  // }

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
                  }

                  return null;
                },
              );
            }

            return _buildEmptyOrErrorUI(
                'No Route blogs yet. Pull down to refresh.');
          },
        ),
      ),
    );
  }
}
