import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/groups/entities/group.dart';
import 'package:tracio_fe/presentation/groups/pages/group_detail.dart';

class RecommendGroupItem extends StatelessWidget {
  final Group group;

  const RecommendGroupItem({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSize.borderRadiusLarge),
      onTap: () async {
        AppNavigator.push(
            context,
            GroupDetailScreen(
              groupId: group.groupId,
            ));
      },
      child: Ink(
        padding: const EdgeInsets.all(AppSize.apHorizontalPadding * 0.7),
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
                group.groupThumbnail,
                width: AppSize.imageSmall.w,
                height: AppSize.imageSmall.w,
                fit: BoxFit.cover,
                errorBuilder: (context, url, error) => Container(
                  width: AppSize.imageSmall.w,
                  height: AppSize.imageSmall.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.error,
                      color: AppColors.background,
                    ),
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Group Info
            Text(
              group.groupName,
              maxLines: 2,
              style: TextStyle(
                  fontSize: AppSize.textTitle * 0.5.sp,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              "${group.district}, ${group.city}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: AppSize.textSmall.sp, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              '${group.participantCount} members',
              style: TextStyle(
                  fontSize: AppSize.textSmall.sp, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),

            RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: 'Created by ',
                style: TextStyle(
                  fontSize: AppSize.textSmall.sp,
                  color: Colors.grey.shade700,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: group.creator.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSize.textSmall.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Spacer(),
            // Join Button
            SizedBox(
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
      ),
    );
  }
}
