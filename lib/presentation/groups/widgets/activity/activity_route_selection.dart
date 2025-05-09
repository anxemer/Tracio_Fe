import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/presentation/library/widgets/feature_section.dart';
import 'package:Tracio/presentation/library/widgets/route_item.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:Tracio/presentation/map/pages/route_planner.dart';

class ActivityRouteSelection extends StatefulWidget {
  const ActivityRouteSelection({super.key});

  @override
  State<ActivityRouteSelection> createState() => _ActivityRouteSelectionState();
}

class _ActivityRouteSelectionState extends State<ActivityRouteSelection> {
  Future<void> _fetchRoutes() async {
    await context.read<RouteCubit>().getPlans(null, pageSize: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<RouteCubit, RouteState>(
        listener: (context, state) {
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
                if (state is GetRouteLoaded && state.plans.isNotEmpty)
                  ...state.plans.map((route) => GestureDetector(
                      onTap: () => Navigator.pop(context, route),
                      child: RouteItem(routeData: route))),
                if ((state is GetRouteLoaded && state.plans.isEmpty) ||
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
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
