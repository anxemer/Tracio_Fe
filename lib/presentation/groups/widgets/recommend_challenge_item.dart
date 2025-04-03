import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

class RecommendChallengeItem extends StatelessWidget {
  final String groupImageUrl;
  final String groupName;
  final String address;
  final int memberCount;

  const RecommendChallengeItem({
    super.key,
    required this.groupImageUrl,
    required this.groupName,
    required this.address,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSize.apHorizontalPadding * 0.7),
      // width: MediaQuery.of(context).size.width * 0.4,
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width / 2.w - 10,
        maxWidth: MediaQuery.of(context).size.width / 2.w - 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              groupImageUrl,
              width: AppSize.imageSmall.w,
              height: AppSize.imageSmall.w,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          // Group Info
          Text(
            groupName,
            maxLines: 2,
            style: TextStyle(
                fontSize: AppSize.textTitle * 0.5.sp,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: AppSize.textSmall.sp, color: Colors.grey.shade700),
          ),
          SizedBox(height: 4),
          Text(
            '$memberCount members',
            style: TextStyle(
                fontSize: AppSize.textSmall.sp, color: Colors.grey.shade700),
          ),
          SizedBox(height: 12),
          // Join Button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: AppSize.apVerticalPadding / 2),
                backgroundColor: AppColors.secondBackground,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSize.borderRadiusMedium),
                ),
              ),
              child: Text(
                'Join',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: AppSize.textSmall.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
