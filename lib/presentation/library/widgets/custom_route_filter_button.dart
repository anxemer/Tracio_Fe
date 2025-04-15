import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

class CustomRouteFilterButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final VoidCallback onPressed;
  final bool isActive;

  const CustomRouteFilterButton({
    super.key,
    this.icon,
    required this.text,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isActive ? AppColors.secondBackground : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    icon != null
                        ? Icon(
                            icon,
                            size: AppSize.iconSmall,
                            color: isActive ? Colors.white : Colors.black87,
                          )
                        : SizedBox.shrink(),
                    SizedBox(width: 5),
                    Text(
                      text,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.black87,
                        fontSize: AppSize.textSmall.sp,
                        fontWeight:
                            isActive ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: AppSize.iconSmall,
                  color: isActive ? Colors.white : Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
