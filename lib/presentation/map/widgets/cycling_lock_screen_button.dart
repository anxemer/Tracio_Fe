import 'package:flutter/material.dart';
import 'package:Tracio/core/constants/app_size.dart';

class CyclingLockScreenButton extends StatefulWidget {
  final VoidCallback onCallBack;
  const CyclingLockScreenButton({super.key, required this.onCallBack});

  @override
  State<CyclingLockScreenButton> createState() =>
      _CyclingLockScreenButtonState();
}

class _CyclingLockScreenButtonState extends State<CyclingLockScreenButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
          minimumSize: Size(50, 50), backgroundColor: Colors.grey.shade200),
      onPressed: () {
        widget.onCallBack();
      },
      icon: Icon(
        Icons.lock_rounded,
        color: Colors.grey.shade800,
      ),
      iconSize: AppSize.iconLarge,
    );
  }
}
