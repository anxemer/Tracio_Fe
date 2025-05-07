import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/challenge/entities/challenge_reward.dart';

class ChallengeReward extends StatelessWidget {
  const ChallengeReward({super.key, required this.reward});
  final ChallengeRewardEntity reward;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CirclePicture(
          imageUrl: reward.imageUrl!, imageSize: AppSize.iconMedium.sp),
      title: Text(
        reward.name!,
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: AppSize.textSmall),
      ),
      subtitle: Text(
        reward.description!,
        style: TextStyle(color: Colors.grey.shade600),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
