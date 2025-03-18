import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/presentation/library/widgets/feature_section.dart';
import 'package:tracio_fe/presentation/library/widgets/route_list.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/route_state.dart';
import 'package:tracio_fe/presentation/map/pages/route_planner.dart';

class RouteTab extends StatefulWidget {
  const RouteTab({super.key});

  @override
  State<RouteTab> createState() => _RouteTabState();
}

class _RouteTabState extends State<RouteTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final GetRouteReq request =
        GetRouteReq(pageNumber: 1, rowsPerPage: 10, sortDesc: false);
    Future.microtask(() {
      context.read<RouteCubit>().getRoutes(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        final GetRouteReq request =
            GetRouteReq(pageNumber: 1, rowsPerPage: 10, sortDesc: false);
        context.read<RouteCubit>().getRoutes(request);
      },
      child: BlocConsumer<RouteCubit, RouteState>(
          builder: (context, state) {
            if (state is GetRouteLoaded) {
              return RouteList();
            } else if (state is GetRouteLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetRouteFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else {
              return Column(
                children: [
                  FeatureSection(
                    banner: Image.asset("assets/images/routes.png"),
                    title: "Plan Your Own Routes",
                    description:
                        "Use the Mobile Route Planner to plan your routes, in advance or on-the-fly, with turn-by-turn directions, waypoints, estimated ride times, and custom cues.",
                    buttonText: "Start Planning",
                    onPressed: () => _navigateTo(context, RoutePlanner()),
                  ),
                ],
              );
            }
          },
          listener: (context, state) {}),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
