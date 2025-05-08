import 'package:Tracio/presentation/library/bloc/route_filter_cubit.dart';
import 'package:Tracio/presentation/library/bloc/route_filter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/presentation/library/widgets/rides_list.dart';
import 'package:Tracio/presentation/library/widgets/route_filter_widget.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';

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
    _fetchWithCurrentFilter();
  }

  Future<void> _fetchWithCurrentFilter() async {
    final filterState = context.read<RouteFilterCubit>().state;
    final filterParams = filterState.toParams();
    final routeState = context.read<RouteCubit>().state;

    final loadedState = routeState is GetRouteLoaded ? routeState : null;

    await context.read<RouteCubit>().getRides(
          loadedState,
          pageNumber: 1,
          filterParams: filterParams,
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        BlocListener<RouteFilterCubit, RouteFilterState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, filterState) {
            _fetchWithCurrentFilter();
          },
          child: BlocBuilder<RouteCubit, RouteState>(builder: (context, state) {
            if (state is GetRouteLoaded && state.rides.isNotEmpty) {
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
        ),
        Expanded(child: RidesList())
      ],
    );
  }
}
