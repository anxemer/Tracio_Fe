import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/groups/cubit/form_group_activity_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/form_group_activity_state.dart';
import 'package:Tracio/presentation/map/bloc/get_location_cubit.dart';
import 'package:Tracio/presentation/map/bloc/get_location_state.dart';
import 'package:Tracio/presentation/map/widgets/search_location_input.dart';

class ActivitySearchLocation extends StatefulWidget {
  final BuildContext bottomSheetContext;
  final ScrollController scrollController;

  const ActivitySearchLocation({
    super.key,
    required this.scrollController,
    required this.bottomSheetContext,
  });
  @override
  State<ActivitySearchLocation> createState() => _ActivitySearchLocationState();
}

class _ActivitySearchLocationState extends State<ActivitySearchLocation> {
  bool isReset = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetLocationCubit, GetLocationState>(
        listener: (context, state) {
      if (state is GetLocationDetailLoaded) {
        context.read<FormGroupActivityCubit>().updateMeetingAddress(
              state.placeDetail.address,
            );
        context.read<FormGroupActivityCubit>().updateMeetingLocation(
              Position(
                state.placeDetail.longitude,
                state.placeDetail.latitude,
              ),
            );
        Navigator.pop(widget.bottomSheetContext, state.placeDetail);
      } else if (state is GetLocationDetailFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Something went wrong, please try later!\n${state.errorMessage.toString()}')),
        );
      }
    }, child: BlocBuilder<FormGroupActivityCubit, FormGroupActivityState>(
      builder: (context, state) {
        return SingleChildScrollView(
          controller: widget.scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SearchLocationInput(
                searchedText: state.meetingAddress,
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
              BlocBuilder<GetLocationCubit, GetLocationState>(
                builder: (context, state) {
                  if (state is GetLocationsAutoCompleteLoading) {
                    return SizedBox(
                      height: 120,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      ),
                    );
                  }

                  if (state is GetLocationsAutoCompleteLoaded) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.places.length,
                      itemBuilder: (context, index) {
                        final place = state.places[index];
                        return ListTile(
                          leading:
                              const Icon(Icons.location_on, color: Colors.blue),
                          title: Text(place.mainText),
                          subtitle: Text(place.secondaryText),
                          onTap: () {
                            context
                                .read<GetLocationCubit>()
                                .getLocationDetail(place.placeId);
                          },
                        );
                      },
                    );
                  }
                  if (state is GetLocationsAutoCompleteFailure) {
                    return Center(
                      child: Text(
                        state.errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    );
                  }
                  if (state is GetLocationDetailFailure) {
                    return Center(
                      child: Text(
                        state.errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              )
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
