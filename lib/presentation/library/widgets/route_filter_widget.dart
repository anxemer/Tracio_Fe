import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/library/bloc/route_filter_cubit.dart';
import 'package:tracio_fe/presentation/library/bloc/route_filter_state.dart';
import 'package:tracio_fe/presentation/library/widgets/custom_route_filter_button.dart';
import 'package:tracio_fe/presentation/library/widgets/route_date_range_filter.dart';
import 'package:tracio_fe/presentation/library/widgets/route_location_filter.dart';
import 'package:tracio_fe/presentation/library/widgets/route_range_slider_widget.dart';
import 'package:tracio_fe/presentation/library/widgets/route_sort_menu.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';

class RouteFilterWidget extends StatefulWidget {
  const RouteFilterWidget({super.key});

  @override
  State<RouteFilterWidget> createState() => _RouteFilterWidgetState();
}

class _RouteFilterWidgetState extends State<RouteFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.apHorizontalPadding / 2),
        child: BlocBuilder<RouteFilterCubit, RouteFilterState>(
            builder: (context, state) {
          return Row(
            spacing: 8,
            children: [
              RouteSortMenu(),
              CustomRouteFilterButton(
                text: state.dateString,
                onPressed: () => showFilterDateRangeModal(context),
                isActive: state.activeField["date"]!,
              ),
              CustomRouteFilterButton(
                icon: Icons.location_on_outlined,
                text: state.activeField["location"]!
                    ? "${state.location}"
                    : "Location",
                onPressed: () => showFilterLocationModal(context),
                isActive: state.activeField["location"]!,
              ),
              CustomRouteFilterButton(
                text: state.activeField["length"]!
                    ? "${state.lengthStart} - ${state.lengthEnd} km"
                    : "Length",
                isActive: state.activeField["length"]!,
                onPressed: () => showFilterSliderModal(context, "length"),
              ),
              CustomRouteFilterButton(
                text: state.activeField["elevation"]!
                    ? "${state.elevationStart} - ${state.elevationEnd} ft"
                    : "Elevation",
                isActive: state.activeField["elevation"]!,
                onPressed: () => showFilterSliderModal(context, "elevation"),
              ),
              CustomRouteFilterButton(
                text: state.activeField["moving_time"]!
                    ? "${state.movingTimeStart} - ${state.movingTimeEnd} hrs"
                    : "Moving Time",
                isActive: state.activeField["moving_time"]!,
                onPressed: () => showFilterSliderModal(context, "moving_time"),
              ),
              CustomRouteFilterButton(
                text: state.activeField["speed"]!
                    ? "${state.speedStart} - ${state.speedEnd} km/h"
                    : "Average Speed",
                isActive: state.activeField["speed"]!,
                onPressed: () => showFilterSliderModal(context, "speed"),
              ),
            ],
          );
        }),
      ),
    );
  }

  void showFilterSliderModal(BuildContext context, String filterType) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      constraints: BoxConstraints(minHeight: AppSize.bannerHeight.h),
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider<RouteFilterCubit>.value(
          value: BlocProvider.of<RouteFilterCubit>(context),
          child: RouteRangeSliderWidget(filterType: filterType),
        );
      },
    );
  }

  void showFilterLocationModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      context: context,
      isScrollControlled: true, // ✅ Allows full-height adjustment
      builder: (_) {
        return BlocProvider(
          create: (context) => GetLocationCubit(),
          child: BlocProvider<RouteFilterCubit>.value(
            value: BlocProvider.of<RouteFilterCubit>(context),
            child: DraggableScrollableSheet(
              expand: false, 
              builder: (_, scrollController) {
                return RouteLocationFilter(scrollController: scrollController);
              },
            ),
          ),
        );
      },
    );
  }

  void showFilterDateRangeModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(),
      constraints: BoxConstraints(minHeight: AppSize.bannerHeight.h),
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider<RouteFilterCubit>.value(
          value: BlocProvider.of<RouteFilterCubit>(context),
          child: RouteDateRangeFilter(),
        );
      },
    );
  }
}
