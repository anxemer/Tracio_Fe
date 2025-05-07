import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Tracio/core/constants/app_size.dart';

class RouteReviewInputBox extends StatefulWidget {
  final TextEditingController textEditingController;
  final void Function(
      XFile? file, int? reviewId, int? replyId, String? userName) onSent;
  const RouteReviewInputBox(
      {super.key, required this.onSent, required this.textEditingController});

  @override
  State<RouteReviewInputBox> createState() => _RouteReviewInputBoxState();
}

class _RouteReviewInputBoxState extends State<RouteReviewInputBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: 8.0, horizontal: AppSize.apHorizontalPadding / 2),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12.sp,
                  ),
                  children: [
                    const TextSpan(text: "Replying to "),
                    TextSpan(
                      text: "David Bui",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.cancel_outlined,
                size: AppSize.iconSmall,
                color: Colors.black87,
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: Border(
              top: BorderSide(width: 1, color: Colors.grey.shade200),
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              prefixText: "@David Bui ",
              prefixStyle: TextStyle(color: Colors.blue),
              hintText: "Add a comment, @ to mention",
              hintStyle: TextStyle(fontSize: AppSize.textMedium.sp),
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.zero,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppSize.apVerticalPadding,
                horizontal: AppSize.apHorizontalPadding,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
