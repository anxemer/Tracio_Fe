import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/presentation/map/bloc/get_location_cubit.dart';
import 'package:Tracio/presentation/map/bloc/get_location_state.dart';

class SearchLocationResult extends StatelessWidget {
  final BuildContext? parentContext;
  const SearchLocationResult({super.key, this.parentContext});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetLocationCubit, GetLocationState>(
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
                leading: const Icon(Icons.location_on, color: Colors.blue),
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
        if (state is GetLocationDetailLoaded) {
          Future.microtask(() {
            if (parentContext != null && 
                parentContext!.mounted && 
                !parentContext!.widget.toString().contains('ActivitySearchLocation')) {
              Navigator.pop(parentContext!, state.placeDetail);
            } else if (context.mounted && 
                      !context.widget.toString().contains('ActivitySearchLocation')) {
              Navigator.pop(context, state.placeDetail);
            }
          });
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
    );
  }
}
