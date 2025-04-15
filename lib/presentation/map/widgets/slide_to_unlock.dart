import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

class SlideToUnlock extends StatelessWidget {
  final VoidCallback onCallBack;

  const SlideToUnlock({
    super.key,
    required this.onCallBack,
  });

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      outerColor: Colors.grey.shade800,
      height: AppSize.buttonHeight,
      elevation: 0,
      sliderButtonIconPadding: 8.0,
      sliderButtonIcon: Icon(
        Icons.lock_outline,
        color: Colors.grey.shade800,
      ),
      sliderButtonIconSize: AppSize.iconSmall,
      child: Text(
        "Swipe to unlock",
        style: TextStyle(
            fontSize: AppSize.textMedium.sp, color: Colors.grey.shade200),
      ),
      onSubmit: () {
        onCallBack();
        return;
      },
    );
  }
}
