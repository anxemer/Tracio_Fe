import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';

import '../../../common/widget/button/button.dart';
import '../../../core/constants/app_size.dart';

class AnimatedFollowButton extends StatefulWidget {
  final VoidCallback onFollow;

  // Thêm các tham số để tùy chỉnh giao diện nút Follow ban đầu nếu cần
  final Color initialFillColor;
  final Color initialBorderColor;
  final Color initialTextColor;
  final double? width; // Cho phép tùy chỉnh kích thước
  final double? height;

  const AnimatedFollowButton({
    Key? key,
    required this.onFollow,
    this.initialFillColor = Colors.transparent,
    this.initialBorderColor = Colors.black,
    this.initialTextColor = Colors.black,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  _AnimatedFollowButtonState createState() => _AnimatedFollowButtonState();
}

// Enum để quản lý các trạng thái của nút
enum FollowButtonState { idle, processing, done }

class _AnimatedFollowButtonState extends State<AnimatedFollowButton> {
  FollowButtonState _currentState = FollowButtonState.idle;
  bool _isVisible = true;

  void _handleFollow() {
    if (_currentState == FollowButtonState.idle) {
      widget.onFollow();
      setState(() {
        _currentState = FollowButtonState.processing;
      });

      Timer(const Duration(milliseconds: 1200), () {
        if (mounted) {
          setState(() {
            _currentState = FollowButtonState.done;
          });
          Timer(const Duration(milliseconds: 300), () {
            if (mounted) {
              setState(() {
                _isVisible = false;
              });
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = widget.width ?? 80.w;
    final double buttonHeight = widget.height ?? 30.h;
    final double fontSize = AppSize.textSmall;

    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: _buildChild(buttonWidth, buttonHeight, fontSize),
        ),
      ),
    );
  }

  Widget _buildChild(double width, double height, double fontSize) {
    switch (_currentState) {
      case FollowButtonState.idle:
        // Sử dụng ButtonDesign của bạn ở đây
        return ButtonDesign(
          key: const ValueKey('follow_button'),
          width: width,
          height: height,
          ontap: _handleFollow,
          fillColor: widget.initialFillColor,
          borderColor: AppColors.secondBackground,
          textColor: widget.initialTextColor,
          fontSize: fontSize,
          text: 'Follow',
        );
      case FollowButtonState.processing:
      case FollowButtonState.done:
        return Container(
          key: const ValueKey('check_icon'),
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSize.borderRadiusMedium),
              border: Border.all(
                color: AppColors.primary,
                width: 1.5.w,
              )),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: (height * 0.6).h,
          ),
        );
    }
  }
}
