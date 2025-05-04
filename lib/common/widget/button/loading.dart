import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        color: AppColors.secondBackground,
        size: AppSize.iconExtraLarge,
      ),
    );
  }
}
