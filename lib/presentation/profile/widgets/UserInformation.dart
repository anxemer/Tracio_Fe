import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/user/entities/user_profile_entity.dart';
import 'package:Tracio/presentation/profile/widgets/vital_tile.dart';

class Userinformation extends StatelessWidget {
  const Userinformation({super.key, required this.user});
  final UserProfileEntity user;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.apVerticalPadding * .2.h),
      width: double.infinity,
      // height: 400.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 255, 255, 255)),
      child: Column(
        children: [
          // Avatar
          CirclePicture(
              imageUrl: user.profilePicture!, imageSize: AppSize.imageSmall.sp),
          // CircleAvatar(
          //   radius: 50,
          //   backgroundColor: Colors.grey[300],
          //   child: const Icon(Icons.person, size: 60),
          // ),
          const SizedBox(height: 12),

          // Name & Email
          Text(
            user.userName!,
            style: TextStyle(
                fontSize: AppSize.textHeading, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user.email!,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 20),
          Text(
            user.bio!,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 20),
          // Gender, Age, Height, Weight
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(TextSpan(
                  text: 'Gender: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: AppSize.textLarge),
                  children: [
                    TextSpan(
                        text: user.gender,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: AppSize.textLarge))
                  ],
                )),
                Text.rich(TextSpan(
                  text: 'BirthDate: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: AppSize.textLarge),
                  children: [
                    TextSpan(
                        text: user.birthDate ?? '24/04/2003',
                        style: TextStyle(fontWeight: FontWeight.normal))
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(TextSpan(
                  text: 'Follower: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: AppSize.textLarge),
                  children: [
                    TextSpan(
                        text: user.followers.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: AppSize.textLarge))
                  ],
                )),
                Text.rich(TextSpan(
                  text: 'Following: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: AppSize.textLarge),
                  children: [
                    TextSpan(
                        text: user.followings.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: AppSize.textLarge))
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            spacing: 10.w,
            mainAxisSize: MainAxisSize.min,
            children: [
              rewardItem(
                  'https://hoanghamobile.com/tin-tuc/wp-content/uploads/2024/09/lich-thi-dau-cktg-2024-5.jpg',
                  'run 50km'),
              rewardItem(
                  'https://cdnmedia.webthethao.vn/uploads/2021-05-20/msi-2021-chung-ket.jpg',
                  'run 30 hours'),
            ],
          ),
          // Average Vitals Label + Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Text(
                'Achievements',
                style: TextStyle(
                    fontSize: AppSize.textHeading, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Vital Items
          VitalTile(
            icon: Icons.directions_bike_outlined,
            title: 'Total Distance',
            value: '500 KM',
          ),
          VitalTile(
            icon: Icons.timer_outlined,
            title: 'Total Duration',
            value: '1000 Hour',
          ),
          VitalTile(
            icon: Icons.route_outlined,
            title: 'Total Route',
            value: '30',
          ),
          VitalTile(
            icon: Icons.photo_size_select_actual_outlined,
            title: 'Total Blog',
            value: '50',
          ),
        ],
      ),
    );
  }

  Widget rewardItem(String imageUrl, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: CirclePicture(
              imageUrl: imageUrl, imageSize: AppSize.iconMedium.sp),
          // Image.network(
          //   imageUrl,
          //   width: 30,
          //   height: 30,
          //   fit: BoxFit.cover,
          // ),
        ),
        SizedBox(height: 8),
        // Title below the image
        Text(
          title, // Dynamic title
          style: TextStyle(
              fontSize: AppSize.textMedium * 0.8.sp,
              fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  // Widget rowText(String lable, String text) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 40),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: const [
  //         Text.rich(TextSpan(
  //           text: 'Height: ',
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //           children: [
  //             TextSpan(
  //                 text: '174 cms',
  //                 style: TextStyle(fontWeight: FontWeight.normal))
  //           ],
  //         )),
  //         Text.rich(TextSpan(
  //           text: 'Weight: ',
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //           children: [
  //             TextSpan(
  //                 text: '68 kgs',
  //                 style: TextStyle(fontWeight: FontWeight.normal))
  //           ],
  //         )),
  //       ],
  //     ),
  //   );
  // }
}
