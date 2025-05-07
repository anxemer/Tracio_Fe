import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';

import '../../../common/widget/button/button.dart';
import '../../../core/constants/app_size.dart';

class AnimatedFollowButton extends StatefulWidget {
  final VoidCallback onFollow;
  final VoidCallback? onUnfollow; // nullable
  final bool initiallyFollowed;
  final bool alwaysVisible;

  final Color initialFillColor;
  final Color initialBorderColor;
  final Color initialTextColor;
  final double? width;
  final double? height;

  const AnimatedFollowButton({
    Key? key,
    required this.onFollow,
    this.onUnfollow,
    this.initiallyFollowed = false,
    this.initialFillColor = Colors.transparent,
    this.initialBorderColor = Colors.black,
    this.initialTextColor = Colors.black,
    this.width,
    this.height,
    this.alwaysVisible = false,
  }) : super(key: key);

  @override
  _AnimatedFollowButtonState createState() => _AnimatedFollowButtonState();
}

enum FollowButtonState { idle, processing, done }

class _AnimatedFollowButtonState extends State<AnimatedFollowButton> {
  FollowButtonState _currentState = FollowButtonState.idle;
  bool _isVisible = true;
  late bool _isFollowed;

  @override
  void initState() {
    super.initState();
    _isFollowed = widget.initiallyFollowed;
  }

  void _handleToggleFollow() {
    if (_currentState == FollowButtonState.idle) {
      setState(() {
        _currentState = FollowButtonState.processing;
      });

      if (!_isFollowed) {
        widget.onFollow();

        if (!widget.alwaysVisible) {
          _isVisible = false;
        }
      } else {
        widget.onUnfollow!();

        if (!widget.alwaysVisible) {
          _isVisible = false;
        }
      }
      Timer(const Duration(milliseconds: 1200), () {
        if (mounted) {
          setState(() {
            _currentState = FollowButtonState.done;
            _isFollowed = !_isFollowed; // đảo trạng thái follow
          });

          Timer(const Duration(milliseconds: 300), () {
            if (mounted) {
              setState(() {
                _currentState = FollowButtonState.idle;
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
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
          child: _buildChild(buttonWidth, buttonHeight, fontSize),
        ),
      ),
    );
  }

  Widget _buildChild(double width, double height, double fontSize) {
    switch (_currentState) {
      case FollowButtonState.idle:
        return ButtonDesign(
          key: ValueKey(_isFollowed ? 'unfollow_button' : 'follow_button'),
          width: width,
          height: height,
          ontap: _handleToggleFollow,
          fillColor: widget.initialFillColor,
          borderColor: AppColors.secondBackground,
          textColor: widget.initialTextColor,
          fontSize: fontSize,
          text: _isFollowed ? 'Following' : 'Follow',
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
            ),
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: (height * 0.6).h,
          ),
        );
    }
  }
}
