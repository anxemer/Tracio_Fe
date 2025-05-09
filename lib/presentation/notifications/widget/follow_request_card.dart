import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/user/entities/follow_request_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowRequestCard extends StatelessWidget {
  final FollowRequestEntity follow;
  final VoidCallback onAccept;
  final VoidCallback onDelete;

  const FollowRequestCard({
    super.key,
    required this.onAccept,
    required this.onDelete,
    required this.follow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0, // Độ nổi của card, tương tự box-shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Để card co lại vừa với nội dung
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CirclePicture(
                    imageUrl: follow.followerAvatarUrl!,
                    imageSize: AppSize.iconMedium.sp),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    follow.followerName!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSize.textMedium,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primary, // Màu xanh dương của Facebook
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side:
                          BorderSide(color: Colors.grey[400]!), // Viền nút Xóa
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
