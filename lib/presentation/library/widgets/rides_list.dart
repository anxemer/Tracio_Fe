import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/presentation/library/widgets/feature_section.dart';
import 'package:Tracio/presentation/library/widgets/route_item.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:Tracio/presentation/map/pages/cycling.dart';
import 'package:flutter/cupertino.dart';

class RidesList extends StatefulWidget {
  const RidesList({super.key});

  @override
  State<RidesList> createState() => _RidesListState();
}

class _RidesListState extends State<RidesList> {
  int _currentPage = 1;
  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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

    final pagination = state.ridePagination;
    final hasMore = pagination?.hasNextPage ?? false;

    if (!hasMore) return;

    _isFetchingMore = true;
    _currentPage++;

    await context.read<RouteCubit>().getRides(state, pageNumber: _currentPage);

    _isFetchingMore = false;
  }

  Future<void> _fetchRoutes() async {
    final currentState = context.read<RouteCubit>().state;
    final loadedState = currentState is GetRouteLoaded ? currentState : null;

    _currentPage = 1;
    await context.read<RouteCubit>().getRides(loadedState, pageNumber: 1);
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
        final rides = isLoaded ? state.rides : [];

        return CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: _fetchRoutes,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (rides.isNotEmpty)
                    ...rides.map((route) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RouteItem(routeData: route),
                        )),
                  if ((isLoaded && rides.isEmpty) || state is GetRouteFailure)
                    FeatureSection(
                      banner: Image.asset("assets/images/rides.png"),
                      title: "Cycling Mode",
                      description:
                          "Track your rides and enjoy guided cycling with real-time metrics and insights.",
                      buttonText: "Start Riding",
                      onPressed: () => _navigateTo(context, CyclingPage()),
                    ),
                  if (_isFetchingMore)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (isLoaded && state.rides.isNotEmpty && !state.hasMoreRides)
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
