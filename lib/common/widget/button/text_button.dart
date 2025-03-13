import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicTextButton extends StatelessWidget {
  const BasicTextButton({super.key, required this.text, required this.onPress});
  final String text;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 32.sp, color: Colors.black),
      ),
    );
  }
}
