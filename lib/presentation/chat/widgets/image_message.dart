import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageMessage extends StatelessWidget {
  final String? imageUrl;
  final File? file;
  final double borderRadius;
  final double width;
  final double height;

  const ImageMessage({
    super.key,
    this.imageUrl,
    this.file,
    this.borderRadius = 12.0,
    this.width = 180,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: width,
      height: height,
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (file != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.file(
          file!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _errorWidget(),
        ),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholder: (context, url) => _placeholder(),
          errorWidget: (context, url, error) => _errorWidget(),
        ),
      );
    } else {
      return _errorWidget();
    }
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _errorWidget() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
      ),
    );
  }
}
