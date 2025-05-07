import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/data/map/models/request/get_route_req.dart';
import 'package:Tracio/presentation/library/widgets/feature_section.dart';
import 'package:Tracio/presentation/library/widgets/route_item.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:Tracio/presentation/map/pages/route_planner.dart';

class RouteList extends StatefulWidget {
  const RouteList({super.key});

  @override
  State<RouteList> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  Future<void> _fetchRoutes() async {
    final GetRouteReq request =
        GetRouteReq(pageNumber: 1, pageSize: 5, sortAsc: false);
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
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _fetchRoutes,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              if (state is GetRouteLoaded && state.routes.isNotEmpty)
                ...state.routes.map((route) => RouteItem(routeData: route)),
              if ((state is GetRouteLoaded && state.routes.isEmpty) ||
                  state is GetRouteFailure)
                Column(
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
                ),
            ],
          ),
        );
      },
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
