import 'dart:math';

import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton(
      {super.key,
      required this.elevation,
      this.heroTag,
      required this.backgroundColor,
      required this.onPressed,
      required this.action});
  final double elevation;
  final String? heroTag;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        elevation: elevation,
        heroTag: heroTag,
        backgroundColor: backgroundColor,
        mini: true,
        shape: CircleBorder(),
        onPressed: onPressed,
        child: action);
  }
}
