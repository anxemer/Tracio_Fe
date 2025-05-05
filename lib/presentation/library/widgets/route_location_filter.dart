import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/drag_handle/drag_handle.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/library/bloc/route_filter_cubit.dart';
import 'package:tracio_fe/presentation/library/bloc/route_filter_state.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_state.dart';
import 'package:tracio_fe/presentation/map/widgets/search_location_input.dart';
import 'package:tracio_fe/presentation/map/widgets/search_location_result.dart';

class RouteLocationFilter extends StatefulWidget {
  final ScrollController scrollController;

  const RouteLocationFilter({super.key, required this.scrollController});

  @override
  State<RouteLocationFilter> createState() => _RouteLocationFilterState();
}

class _RouteLocationFilterState extends State<RouteLocationFilter> {
  bool isReset = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetLocationCubit, GetLocationState>(
        listener: (context, state) {
      if (state is GetLocationDetailLoaded) {
        context.read<RouteFilterCubit>().setLocation(
              state.placeDetail.name,
              longitude: state.placeDetail.longitude,
              latitude: state.placeDetail.latitude,
            );
      } else if (state is GetLocationDetailFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Something went wrong, please try later!\n${state.errorMessage.toString()}')),
        );
      }
    }, child: BlocBuilder<RouteFilterCubit, RouteFilterState>(
      builder: (context, state) {
        return SingleChildScrollView(
          controller: widget.scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSize.apHorizontalPadding,
                  AppSize.apVerticalPadding / 2,
                  AppSize.apHorizontalPadding,
                  AppSize.apVerticalPadding / 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DragHandle(height: 6, color: Colors.grey.shade400),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isReset = true;
                            });
                          },
                          child: const Text(
                            "Reset",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                        Text(
                          "Location",
                          style: const TextStyle(
                            fontSize: AppSize.textMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (isReset) {
                              context
                                  .read<RouteFilterCubit>()
                                  .resetFilter("location");
                            }
                            setState(() {
                              isReset = false;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("Save",
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SearchLocationInput(
                searchedText: state.location ?? "",
                backgroundColor: Colors.white10,
                showPrefixIcon: false,
                limitResult: 3,
              ),
              Divider(color: Colors.grey.shade300),
              BlocBuilder<GetLocationCubit, GetLocationState>(
                  builder: (context, state) {
                if (state is GetLocationInitial) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.apHorizontalPadding),
                    child: _buildLocationOption(
                      icon: Icons.near_me,
                      text: "Near you",
                      onTap: () {},
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
              SearchLocationResult(),
            ],
          ),
        );
      },
    ));
  }

  Widget _buildLocationOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withValues(alpha: .2),
                border: Border.all(color: Colors.blue, width: 0),
              ),
              padding: EdgeInsets.all(8),
              child: Icon(
                icon,
                color: Colors.blue,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Text(text),
          ],
        ),
      ),
    );
  }
}
