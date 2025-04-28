import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/configs/theme/assets/app_images.dart';
import '../../core/constants/app_size.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: MediaQuery.of(context).size.height - kToolbarHeight,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.error,
              width: AppSize.imageLarge,
            ),
            SizedBox(height: 16.h),
            Text('No blogs yet. Pull down to refresh.'),
          ],
        ),
      ),
    );
  }
}
