import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widget/button/text_button.dart';

class IconBlog extends StatefulWidget {
  const IconBlog(
      {super.key,
      required this.text,
      required this.funtion1,
      required this.funtion2,
      required this.widget});
  final String text;
  final VoidCallback funtion1;
  final VoidCallback funtion2;
  final Widget widget;

  @override
  State<IconBlog> createState() => _IconBlogState();
}

class _IconBlogState extends State<IconBlog> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            onTap: 
              widget.funtion1
            ,
            child: widget.widget),
        SizedBox(
          width: 10.w,
        ),
        BasicTextButton(text: widget.text, onPress: widget.funtion2),
      ],
    );
  }
}
