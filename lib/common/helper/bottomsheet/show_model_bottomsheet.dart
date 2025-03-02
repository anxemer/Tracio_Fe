import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/button/text_button.dart';

// Đặt hàm này trong một file utils hoặc helpers
void showCommentBottomSheetBasic(
    {required BuildContext context,
    double maxChildSize = 0.5,
    double initialChildSize = 0.5,
    double minChildSize = 0.2,
    bool isDismissible = true,
    bool isScrollControlled = true,
    Color backgroundColor = Colors.transparent,
    required Widget widget}) {
  showModalBottomSheet(
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
            maxChildSize: maxChildSize,
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            builder: (context, scrollController) => widget),
      );
    },
  );
}

// Bạn cũng có thể tạo một widget CommentButton riêng sử dụng function này
