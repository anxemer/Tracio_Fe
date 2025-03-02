import 'dart:math';

import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  FloatingButton(
      {super.key,
      this.elevation,
      this.heroTag,
      required this.backgroundColor,
      required this.onPressed,
      required this.action});
  double? elevation;
  final String? heroTag;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        elevation: 0,
        heroTag: heroTag,
        backgroundColor: backgroundColor,
        mini: true,
        // shape: CircleBorder(),
        onPressed: onPressed,
        child: action);
  }
}
