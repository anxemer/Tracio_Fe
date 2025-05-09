import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/presentation/library/widgets/route_filter_widget.dart';
import 'package:Tracio/presentation/library/widgets/route_list.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';

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
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        BlocConsumer<RouteCubit, RouteState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is GetRouteLoaded && state.plans.isNotEmpty) {
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
        Expanded(child: RouteList())
      ],
    );
  }
}
