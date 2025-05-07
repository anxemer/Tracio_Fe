import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_state.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class RouteDetailMapView extends StatefulWidget {
  const RouteDetailMapView({super.key});

  @override
  State<RouteDetailMapView> createState() => _RouteDetailMapViewState();
}

class _RouteDetailMapViewState extends State<RouteDetailMapView> {
  @override
  Widget build(BuildContext context) {
    final mapCubit = BlocProvider.of<MapCubit>(context);
    return BlocBuilder<MapCubit, MapCubitState>(
      builder: (context, state) {
        return mapbox.MapWidget(
          key: const ValueKey("mapWidget"),
          cameraOptions: mapCubit.camera,
          onMapCreated: (map) {
            mapCubit.initializeMap(map,
                locationSetting:
                    mapbox.LocationComponentSettings(enabled: false),
                gesturesSetting: mapbox.GesturesSettings(rotateEnabled: false),
                logoSetting: mapbox.LogoSettings(
                    marginLeft: MediaQuery.of(context).size.width - 100.w,
                    marginBottom: 120.h),
                attributionSetting: mapbox.AttributionSettings(
                    marginLeft: MediaQuery.of(context).size.width - 120.w,
                    marginBottom: 120.h));
          },
          onMapLoadedListener: (loadedListenerEvent) {
            Future.microtask(() async {
              final imageData1 = await context
                  .read<MapCubit>()
                  .getNetworkImageData(Uri.parse(
                      "https://images.unsplash.com/photo-1745500415839-503883982264?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"));

              final imageData2 = await context
                  .read<MapCubit>()
                  .getNetworkImageData(Uri.parse(
                      "https://images.unsplash.com/photo-1744429523595-2c06b8611242?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"));

              await context.read<MapCubit>().addPointAnnotation(
                  mapbox.Position(106.71137, 10.80124), imageData1,
                  iconSize: 3);
              await context.read<MapCubit>().addPointAnnotation(
                  mapbox.Position(106.69903, 10.77583), imageData2,
                  iconSize: 3);
            });
          },
          onTapListener: (tapListenerEvent) async {},
        );
      },
    );
  }
}
