import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/data/map/models/request/get_route_req.dart';
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
                      state.routes
                          .where((route) => !route.isPlanned)
                          .isNotEmpty)
                    ...state.routes
                        .where((route) => !route.isPlanned)
                        .map((route) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: RouteItem(routeData: route),
                            )),
                  if ((state is GetRouteLoaded && state.routes.where((route) => !route.isPlanned).isEmpty) ||
                      state is GetRouteFailure)
                    FeatureSection(
                      banner: Image.asset("assets/images/rides.png"),
                      title: "Cycling Mode",
                      description:
                          "Track your rides and enjoy guided cycling with real-time metrics and insights.",
                      buttonText: "Start Riding",
                      onPressed: () => _navigateTo(context, CyclingPage()),
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
