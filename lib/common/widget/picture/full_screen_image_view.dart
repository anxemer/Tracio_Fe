import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:gal/gal.dart';

class FullScreenImageView extends StatelessWidget {
  final String? imageUrl;
  final File? file;
  final Widget? overlay;

  const FullScreenImageView({
    super.key,
    this.imageUrl,
    this.file,
    this.overlay,
  });

  Future<void> _saveImage(BuildContext context) async {
    try {
      if (file != null) {
        await Gal.putImage(file!.path);
      } else if (imageUrl != null && imageUrl!.isNotEmpty) {
        try {
          final imagePath = '${Directory.systemTemp.path}/image.jpg';
          await Dio().download('$imageUrl', imagePath);
          await Gal.putImage(imagePath);
        } catch (e) {
          throw Exception('Error fetching image: $e');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved to gallery'),
          backgroundColor: Colors.greenAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () => _saveImage(context),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Center(
            child: file != null
                ? PhotoView(
                    imageProvider: FileImage(file!),
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.black),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2.5,
                  )
                : imageUrl != null
                    ? PhotoView(
                        imageProvider: CachedNetworkImageProvider(imageUrl!),
                        backgroundDecoration:
                            const BoxDecoration(color: Colors.black),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2.5,
                      )
                    : const Center(
                        child: Icon(Icons.broken_image,
                            color: Colors.white, size: 80),
                      ),
          ),
          if (overlay != null)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: overlay!,
            )
        ],
      ),
    );
  }
}
