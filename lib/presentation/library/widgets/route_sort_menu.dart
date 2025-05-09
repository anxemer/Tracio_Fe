import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/library/bloc/route_filter_cubit.dart';
import 'package:Tracio/presentation/library/bloc/route_filter_state.dart';

class RouteSortMenu extends StatefulWidget {
  const RouteSortMenu({super.key});

  @override
  State<RouteSortMenu> createState() => _RouteSortMenuState();
}

class _RouteSortMenuState extends State<RouteSortMenu> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteFilterCubit, RouteFilterState>(
        builder: (context, state) {
      return PopupMenuButton<String>(
        key: ValueKey("${state.sortField}_${state.sortDesc}"),
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(width: 1, color: Colors.grey.shade300)))),
        offset: Offset(0, 50),
        color: Colors.white,
        elevation: 4,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        icon: const Icon(
          Icons.filter_list_outlined,
          color: Colors.black87,
          size: AppSize.iconSmall,
        ),
        initialValue: state.sortField,
        onSelected: (value) {
          context.read<RouteFilterCubit>().setSortField(value);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            enabled: false,
            child: Text("Sort by", style: TextStyle(color: Colors.black45)),
          ),
          _buildPopupMenuItem("Date", "CreatedAt",
              currentSortField: state.sortField, sortDesc: state.sortDesc),
          _buildPopupMenuItem("Name", "RouteName",
              currentSortField: state.sortField, sortDesc: state.sortDesc),
          _buildPopupMenuItem("Elevation Gain", "ElevationGain",
              currentSortField: state.sortField, sortDesc: state.sortDesc),
          _buildPopupMenuItem("Average Speed", "AvgSpeed",
              currentSortField: state.sortField, sortDesc: state.sortDesc),
          _buildPopupMenuItem("Moving Time", "MovingTime",
              currentSortField: state.sortField, sortDesc: state.sortDesc),
        ],
      );
    });
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String label,
    String value, {
    required String currentSortField,
    required bool sortDesc,
  }) {
    final isActive = value == currentSortField;
    final icon = !isActive
        ? null
        : sortDesc
            ? Icons.arrow_downward
            : Icons.arrow_upward;

    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          isActive
              ? Icon(Icons.check_outlined,
                  color: Colors.black54, size: AppSize.iconSmall)
              : const SizedBox(width: 20),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: Colors.black54, fontSize: AppSize.textMedium.sp)),
          const Spacer(),
          if (icon != null)
            Icon(icon, size: AppSize.iconSmall, color: Colors.black54),
        ],
      ),
    );
  }
}
