import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/presentation/library/widgets/rides_list.dart';
import 'package:tracio_fe/presentation/library/widgets/route_filter_widget.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/route_state.dart';

class RidesTab extends StatefulWidget {
  const RidesTab({super.key});

  @override
  State<RidesTab> createState() => _RidesTabState();
}

class _RidesTabState extends State<RidesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final GetRouteReq request = GetRouteReq(
        pageNumber: 1, pageSize: 5, sortAsc: false, isPlanned: "false");
    Future.microtask(() {
      context.read<RouteCubit>().getRoutes(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        BlocConsumer<RouteCubit, RouteState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is GetRouteLoaded && state.routes.isNotEmpty) {
                return Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                        horizontal:
                            BorderSide(width: 1, color: Colors.grey.shade300)),
                    color: Colors.grey.shade100,
                  ),
                  child: RouteFilterWidget(),
                );
              } else {
                return Container();
              }
            }),
        Expanded(child: RidesList())
      ],
    );
  }
}
