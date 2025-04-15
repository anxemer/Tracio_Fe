import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

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
