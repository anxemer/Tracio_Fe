import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/presentation/library/widgets/route_item.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/route_state.dart';
import 'package:tracio_fe/domain/map/entities/route.dart';

class RouteList extends StatefulWidget {
  const RouteList({super.key});

  @override
  State<RouteList> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RouteCubit, RouteState>(
      builder: (context, state) {
        if (state is GetRouteLoaded) {
          if (state.routes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("No routes available.",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.routes.length,
            itemBuilder: (context, index) {
              final RouteEntity route = state.routes[index];
              return RouteItem(routeData: route);
            },
          );
        } else {
          return const Center(child: Text("Unknown state"));
        }
      },
      listener: (context, state) {},
    );
  }
}
