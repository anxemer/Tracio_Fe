import 'package:flutter/material.dart';

class DragHandle extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const DragHandle({
    super.key,
    this.width = 60.0, // Default width of the drag handle
    this.height = 8.00, // Default height of the drag handle
    this.color = Colors.grey, // Default color of the drag handle
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width, // Width of the drag handle
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ));
  }
}
