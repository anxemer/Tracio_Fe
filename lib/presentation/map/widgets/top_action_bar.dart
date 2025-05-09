import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:Tracio/core/constants/api_url.dart';
import 'package:Tracio/data/map/models/request/isochrone_req.dart';
import 'package:Tracio/domain/map/entities/place.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_state.dart';
import 'package:Tracio/presentation/map/pages/search_location.dart';

class TopActionBar extends StatelessWidget {
  const TopActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapCubitState>(builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
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
              Navigator.pop(context);
            },
          ),
          // Search location button
          SizedBox(
            width: 0.6.sw,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 10)),
              onPressed: () async {
                dynamic searchedCoordinate = await Navigator.push<dynamic>(
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
                    await context.read<MapCubit>().addPointAnnotation(
                        Position(searchedCoordinate.longitude,
                            searchedCoordinate.latitude),
                        imageData);
                    _showLocationOptions(context, searchedCoordinate);
                  }
                } else if (searchedCoordinate != null &&
                    searchedCoordinate.runtimeType == IsochroneReq) {
                  if (context.mounted) {
                    final uri =
                        ApiUrl.urlGetIsochroneMapbox(searchedCoordinate);
                    context.read<MapCubit>().addPolygonGeoJson(uri);
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
          //TODO: Popup menu
          IconButton(
            style: IconButton.styleFrom(
                elevation: 2,
                shadowColor: Colors.black54,
                backgroundColor: Colors.white,
                alignment: Alignment.center,
                padding: EdgeInsets.zero),
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black54,
            ),
            onPressed: () {},
          ),
        ],
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
    await context.read<MapCubit>().addPointAnnotation(
          Position(place.longitude, place.latitude),
          imageData,
        );
  }

  Future<Uint8List> _getMarkerBytes(String assetPath) async {
    final ByteData bytes = await rootBundle.load(assetPath);
    return bytes.buffer.asUint8List();
  }

  void _addPointOfInterest(PlaceDetailEntity place) {
    print("Adding ${place.address} as a Point of Interest");
  }
}
