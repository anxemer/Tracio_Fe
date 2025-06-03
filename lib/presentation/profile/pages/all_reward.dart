import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/challenge/entities/challenge_reward.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../common/helper/navigator/app_navigator.dart';
import '../../groups/widgets/challenge_progress.dart';

class AllReward extends StatefulWidget {
  const AllReward({super.key, required this.reward});
  final List<ChallengeRewardEntity> reward;
  @override
  State<AllReward> createState() => _AllRewardState();
}

class _AllRewardState extends State<AllReward> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(),
      body: ListView.builder(
        itemCount: widget.reward.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () => AppNavigator.push(
              context,
              ChallengeProgressScreen(
                  challengeId: widget.reward[index].challengeId!)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 10, vertical: AppSize.apVerticalPadding * .2.h),
            child: Card(
                child: ListTile(
              leading: CirclePicture(
                  imageUrl: widget.reward[index].imageUrl!,
                  imageSize: AppSize.imageSmall * .6.sp),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.reward[index].name ?? '',
                    style: TextStyle(
                      fontSize: AppSize.textLarge,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    timeago.format(
                        widget.reward[index].createdAt ?? DateTime.now()),
                    style: TextStyle(
                      fontSize: AppSize.textSmall.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),

              subtitle: Text(widget.reward[index].description!),
              // trailing: Text(
              //   timeago
              //       .format(widget.reward[index].createdAt ?? DateTime.now()),
              //   style: TextStyle(fontSize: AppSize.textSmall.sp),
              // ),
            )),
          ),
        ),
      ),
    );
  }
}
