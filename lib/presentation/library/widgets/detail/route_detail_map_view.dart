import 'package:Tracio/common/widget/picture/full_screen_image_view.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_state.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class AnnotationClickListener extends OnPointAnnotationClickListener {
  final void Function(PointAnnotation annotation) onTap;

  AnnotationClickListener(this.onTap);

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    onTap(annotation);
  }
}

class RouteDetailMapView extends StatefulWidget {
  const RouteDetailMapView({super.key});

  @override
  State<RouteDetailMapView> createState() => _RouteDetailMapViewState();
}

class _RouteDetailMapViewState extends State<RouteDetailMapView> {
  PointAnnotationManager? pointAnnotationManager;

  @override
  Widget build(BuildContext context) {
    final mapCubit = context.read<MapCubit>();

    return BlocListener<RouteCubit, RouteState>(
      listener: (context, state) async {
        if (state is GetRouteDetailLoaded) {
          final markers = <PointAnnotationOptions>[];

          for (var media in state.routeMediaFiles) {
            final loc = media.location;
            if (loc != null) {
              var imageByte =
                  await mapCubit.getNetworkImageData(Uri.parse(media.mediaUrl));
              markers.add(PointAnnotationOptions(
                geometry:
                    Point(coordinates: Position(loc.longitude, loc.latitude)),
                image: imageByte,
                iconSize: 3,
                iconAnchor: IconAnchor.BOTTOM,
              ));
            }
          }

          if (markers.isNotEmpty) {
            await pointAnnotationManager?.createMulti(markers);

            // Add click listener
            pointAnnotationManager?.addOnPointAnnotationClickListener(
              AnnotationClickListener((annotation) {
                final coords = annotation.geometry.coordinates;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageView(
                        imageUrl: state.routeMediaFiles
                            .firstWhere((media) =>
                                media.location?.latitude == coords.lng &&
                                media.location?.longitude == coords.lat)
                            .mediaUrl,
                      ),
                    ));
              }),
            );
          }
        }
      },
      child: BlocBuilder<MapCubit, MapCubitState>(
        builder: (context, _) {
          return MapWidget(
            key: const ValueKey("mapWidget"),
            cameraOptions: mapCubit.camera,
            onMapCreated: (map) async {
              mapCubit.initializeMap(
                map,
                locationSetting: LocationComponentSettings(enabled: false),
                gesturesSetting: GesturesSettings(rotateEnabled: false),
                logoSetting: LogoSettings(
                  marginLeft: MediaQuery.of(context).size.width - 100.w,
                  marginBottom: 120.h,
                ),
                attributionSetting: AttributionSettings(
                  marginLeft: MediaQuery.of(context).size.width - 120.w,
                  marginBottom: 120.h,
                ),
              );

              pointAnnotationManager = await map.annotations
                  .createPointAnnotationManager(below: "polyline-layer");
              pointAnnotationManager?.setIconAllowOverlap(true);
              pointAnnotationManager?.setIconIgnorePlacement(true);
            },
            onTapListener: (_) {},
          );
        },
      ),
    );
  }
}
