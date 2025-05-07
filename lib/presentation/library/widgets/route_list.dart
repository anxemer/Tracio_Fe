import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/presentation/library/widgets/feature_section.dart';
import 'package:tracio_fe/presentation/library/widgets/route_item.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/route_state.dart';
import 'package:tracio_fe/presentation/map/pages/route_planner.dart';
import 'package:flutter/cupertino.dart';

class RouteList extends StatefulWidget {
  const RouteList({super.key});

  @override
  State<RouteList> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  Future<void> _fetchRoutes() async {
    final GetRouteReq request = GetRouteReq(
      pageNumber: 1,
      pageSize: 10,
      sortAsc: false,
    );
    await context.read<RouteCubit>().getRoutes(request);
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
        return CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                await _fetchRoutes();
              },
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (state is GetRouteLoaded &&
                      state.routes.where((route) => route.isPlanned).isNotEmpty)
                    ...state.routes
                        .where((route) => route.isPlanned)
                        .map((route) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: RouteItem(routeData: route),
                            )),
                  if ((state is GetRouteLoaded &&
                          state.routes
                              .where((route) => route.isPlanned)
                              .isEmpty) ||
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
