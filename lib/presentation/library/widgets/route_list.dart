import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/presentation/library/widgets/feature_section.dart';
import 'package:Tracio/presentation/library/widgets/route_item.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:Tracio/presentation/map/pages/route_planner.dart';
import 'package:flutter/cupertino.dart';

class RouteList extends StatefulWidget {
  const RouteList({super.key});

  @override
  State<RouteList> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  int _currentPage = 1;
  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchRoutes();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore) {
      _loadNextPage();
    }
  }

  Future<void> _loadNextPage() async {
    final state = context.read<RouteCubit>().state;
    if (state is! GetRouteLoaded) return;

    final pagination = state.plansPagination;
    final hasMore = pagination?.hasNextPage ?? false;

    if (!hasMore) return;

    _isFetchingMore = true;
    _currentPage++;

    await context.read<RouteCubit>().getPlans(state, pageNumber: _currentPage);

    _isFetchingMore = false;
  }

  Future<void> _fetchRoutes() async {
    final currentState = context.read<RouteCubit>().state;
    final loadedState = currentState is GetRouteLoaded ? currentState : null;

    _currentPage = 1;
    await context.read<RouteCubit>().getPlans(loadedState, pageNumber: 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RouteCubit, RouteState>(
      listener: (context, state) {
        if (!mounted) return;
        if (state is GetRouteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.message),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoaded = state is GetRouteLoaded;
        final plannedRoutes =
            isLoaded ? state.plans.where((r) => r.isPlanned).toList() : [];

        return CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            CupertinoSliverRefreshControl(onRefresh: _fetchRoutes),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (plannedRoutes.isNotEmpty)
                    ...plannedRoutes.map((route) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RouteItem(routeData: route),
                        )),
                  if ((isLoaded && plannedRoutes.isEmpty) ||
                      state is GetRouteFailure)
                    FeatureSection(
                      banner: Image.asset("assets/images/routes.png"),
                      title: "Plan Your Own Routes",
                      description:
                          "Use the Mobile Route Planner to plan your routes, in advance or on-the-fly, with turn-by-turn directions, waypoints, estimated ride times, and custom cues.",
                      buttonText: "Start Planning",
                      onPressed: () =>
                          _navigateTo(context, const RoutePlanner()),
                    ),
                  if (_isFetchingMore)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (isLoaded && state.plans.isNotEmpty && !state.hasMorePlans)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                          child: Text(
                        "The end of the list",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                      )),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
