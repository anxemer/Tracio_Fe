import 'dart:io';

import 'package:Tracio/data/map/models/request/post_route_media_req.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/tracking/bloc/tracking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Tracio/core/constants/app_size.dart';
import "package:flutter_bloc/flutter_bloc.dart";

class CyclingTakePictureButton extends StatelessWidget {
  const CyclingTakePictureButton({super.key});
  Future<void> _takePicture(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        final File imageFile = File(image.path);
        await Gal.putImage(imageFile.path);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo saved to gallery!')),
        );
      }
      // 🔥 Get tracking state
      final trackingState = context.read<TrackingBloc>().state;

      if (trackingState is! TrackingInProgress ||
          trackingState.position == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not available')),
        );
        return;
      }

      final location = trackingState.position!;
      final routeId = trackingState.routeId;

      if (routeId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Route ID not available')),
        );
        return;
      }

      // 🔥 Create request
      final mediaReq = PostRouteMediaReq(
        routeId: routeId,
        mediaFile: File(image!.path),
        latitude: location.coords.latitude,
        longitude: location.coords.longitude,
        altitude: location.coords.altitude,
      );

      await context.read<RouteCubit>().uploadMediaWithLocation(mediaReq);
    } on GalException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.type.message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
          minimumSize: Size(50, 50), backgroundColor: Colors.grey.shade200),
      onPressed: () {
        _takePicture(context);
      },
      icon: Icon(
        Icons.camera_enhance,
        color: Colors.grey.shade800,
      ),
      iconSize: AppSize.iconLarge,
    );
  }
}
