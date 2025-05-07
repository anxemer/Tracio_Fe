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
          //TODO:FETCH DATA
          context.read<RouteFilterCubit>().setSortField(value);
        },
        itemBuilder: (context) => [
          PopupMenuItem(
              enabled: false,
              child: Text(
                "Sort by",
                style: TextStyle(color: Colors.black45),
              )),
          _buildPopupMenuItem("Date", isActive: state.sortField == "Date"),
          _buildPopupMenuItem("Name", isActive: state.sortField == "Name"),
          _buildPopupMenuItem("Length", isActive: state.sortField == "Length"),
          _buildPopupMenuItem("Elevation Gain",
              isActive: state.sortField == "Elevation Gain"),
          _buildPopupMenuItem("Average Speed",
              isActive: state.sortField == "Average Speed"),
          _buildPopupMenuItem("Moving Time",
              isActive: state.sortField == "Moving Time"),
        ],
      );
    });
  }

  PopupMenuItem<String> _buildPopupMenuItem(String text,
      {bool isActive = false}) {
    return PopupMenuItem(
      value: text,
      child: Row(
        children: [
          isActive
              ? Icon(
                  Icons.check_outlined,
                  color: Colors.black54,
                  size: AppSize.iconSmall,
                )
              : SizedBox(width: 20),
          SizedBox(width: 5),
          Text(text,
              style: TextStyle(
                  color: Colors.black54, fontSize: AppSize.textMedium.sp)),
        ],
      ),
    );
  }
}
