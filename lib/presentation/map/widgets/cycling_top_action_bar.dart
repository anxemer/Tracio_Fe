import 'dart:typed_data';

import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:Tracio/common/widget/navbar/bottom_nav_bar_manager.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/map/models/request/mapbox_direction_req.dart';
import 'package:Tracio/domain/map/entities/place.dart';
import 'package:Tracio/presentation/map/bloc/get_direction_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_state.dart';
import 'package:Tracio/presentation/map/pages/search_location.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class CyclingTopActionBar extends StatefulWidget {
  final bool isRiding;
  const CyclingTopActionBar({super.key, required this.isRiding});

  @override
  State<CyclingTopActionBar> createState() => _CyclingTopActionBarState();
}

class _CyclingTopActionBarState extends State<CyclingTopActionBar> {
  Future<Uint8List> _getMarkerBytes(String assetPath) async {
    final ByteData bytes = await rootBundle.load(assetPath);
    return bytes.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapCubitState>(builder: (context, state) {
      return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && Navigator.canPop(context)) {
            AppNavigator.push(context, BottomNavBarManager());
          } else {
            final bottomNavBarState =
                context.findAncestorStateOfType<BottomNavBarManagerState>();
            if (bottomNavBarState != null) {
              bottomNavBarState.setSelectedIndex(0);
              bottomNavBarState.setNavVisible(true);
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.apHorizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              //Options button
              IconButton(
                style: IconButton.styleFrom(
                    elevation: 2,
                    shadowColor: Colors.black54,
                    backgroundColor: Colors.white,
                    alignment: Alignment.center,
                    padding: EdgeInsets.zero),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black54,
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    final bottomNavBarState = context
                        .findAncestorStateOfType<BottomNavBarManagerState>();
                    if (bottomNavBarState != null) {
                      bottomNavBarState.setSelectedIndex(0);
                      bottomNavBarState.setNavVisible(true);
                    }
                  }
                },
              ),
              // Search location button

              if (!widget.isRiding)
                SizedBox(
                  width: 0.6.sw,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 10)),
                    onPressed: () async {
                      dynamic searchedCoordinate =
                          await Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchLocationPage()),
                      );

                      if (searchedCoordinate != null &&
                          searchedCoordinate.runtimeType == PlaceDetailEntity) {
                        if (context.mounted) {
                          context.read<MapCubit>().animateCamera(Position(
                              searchedCoordinate.longitude,
                              searchedCoordinate.latitude));
                          //Search annotation
                          final imageData = await _getMarkerBytes(
                              'assets/images/search_location_marker.png');
                          context.read<MapCubit>().addPointAnnotation(
                              Position(searchedCoordinate.longitude,
                                  searchedCoordinate.latitude),
                              imageData,
                              iconOffset: [-10.0, 20.0],
                              iconSize: 0.5);
                          _showLocationOptions(context, searchedCoordinate);
                        }
                      }
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.search,
                          color: Colors.black38,
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Search location',
                            style: TextStyle(
                                color: Colors.black54,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              //Options button
              PopupMenuButton<String>(
                popUpAnimationStyle: AnimationStyle.noAnimation,
                color: Colors.white,
                offset: Offset(-10, 30),
                icon: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.black54,
                  ),
                ),
                onSelected: (String value) {
                  switch (value) {
                    case 'Route Planner':
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Route Planner',
                    child: Text('Route Planner'),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'Navigation Settings',
                    child: Text('Navigation Settings'),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  void _showLocationOptions(BuildContext context, PlaceDetailEntity place) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      elevation: 2,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                place.address,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.directions, color: Colors.blue),
                title: const Text("Route to Here"),
                onTap: () {
                  _navigateToRoute(context, place);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.green),
                title: const Text("Add Point of Interest"),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _addPointOfInterest(place); // Function to add POI
                },
              ),
            ],
          ),
        );
      },
    ).then((_) {
      if (context.mounted) {
        context.read<MapCubit>().onBottomSheetClosed();
      }
    });
  }

  void _navigateToRoute(BuildContext context, PlaceDetailEntity place) async {
    final imageData =
        await _getMarkerBytes('assets/images/search_location_marker.png');
    context.read<MapCubit>().addPointAnnotation(
        Position(place.longitude, place.latitude), imageData);
    bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition();

    List<Coordinate> coordinates = [
      Coordinate(
        location.coords.longitude,
        location.coords.latitude,
      ),
      Coordinate(
        place.longitude,
        place.latitude,
      )
    ];

    String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;

    final request = MapboxDirectionsRequest(
      profile: 'cycling',
      coordinates: coordinates,
      accessToken: accessToken,
    );

    context.read<GetDirectionCubit>().getDirectionUsingMapbox(request);
  }

  void _addPointOfInterest(PlaceDetailEntity place) {
    print("Adding ${place.address} as a Point of Interest");
  }
}
