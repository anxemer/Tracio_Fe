import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final Color? backgroundColor;
  final bool hideBack;
  final double? height;
  final bool? centralTitle;
  final int? data;
  const BasicAppbar(
      {this.title,
      this.hideBack = false,
      this.action,
      this.backgroundColor,
      this.height,
      super.key,
      this.centralTitle,
      this.data});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: centralTitle ?? false,
      automaticallyImplyLeading: false,
      toolbarHeight: height ?? 80,
      title: title ?? const Text(''),
      titleSpacing: 0,
      actions: [action ?? Container()],
      leading: hideBack
          ? null
          : IconButton(
              onPressed: () {
                Navigator.pop(context, data);
              },
              icon: Container(
                height: 50.h,
                width: 10.w,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 24, color: Colors.black),
              ),
            ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 80);
}
