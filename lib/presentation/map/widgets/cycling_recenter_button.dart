import 'package:flutter/material.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';

class CyclingRecenterButton extends StatelessWidget {
  final bool isCentered;
  final VoidCallback onPressed;

  const CyclingRecenterButton({
    super.key,
    required this.isCentered,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          isCentered ? Icons.my_location : Icons.location_searching,
          color: isCentered ? AppColors.primary : Colors.grey,
          size: 24,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
