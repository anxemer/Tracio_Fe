import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';

class ChooseAudienceBlog extends StatefulWidget {
  const ChooseAudienceBlog({super.key});

  @override
  State<ChooseAudienceBlog> createState() => _ChooseAudienceBlogState();
}

class _ChooseAudienceBlogState extends State<ChooseAudienceBlog> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        data: selectedIndex,
        height: 60.h,
        centralTitle: true,
        title: Text('Audience'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Who can see your post',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            ListTile(
              leading: Image.asset(AppImages.group, width: 40), // Ảnh tiêu đề
              title: const Text('public'),
              trailing: Checkbox(
                checkColor: Colors.black,
                activeColor: Colors.white,
                shape: const CircleBorder(), // Làm checkbox hình tròn
                value: selectedIndex == 0,
                onChanged: (bool? newValue) {
                  setState(() {
                    print(selectedIndex);
                    selectedIndex = newValue == true ? 0 : null;
                    selectedIndex == 0;
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip_outlined,
                size: 40,
              ), // Ảnh tiêu đề
              title: const Text('Private'),
              trailing: Checkbox(
                checkColor: Colors.black,
                activeColor: Colors.white,
                shape: const CircleBorder(), // Làm checkbox hình tròn
                value: selectedIndex == 1,
                onChanged: (bool? newValue) {
                  setState(() {
                    print(selectedIndex);
                    selectedIndex = newValue == true ? 1 : null;
                    selectedIndex == 1;
                  });
                },
              ),
            ),
            ListTile(
              leading: Image.asset(
                AppImages.follower,
                width: 40,
              ), // Ảnh tiêu đề
              title: const Text('Follower Only'),
              trailing: Checkbox(
                checkColor: Colors.black,
                activeColor: Colors.white,
                shape: const CircleBorder(), // Làm checkbox hình tròn
                value: selectedIndex == 2,
                onChanged: (bool? newValue) {
                  setState(() {
                    selectedIndex = newValue == true ? 2 : null;
                    selectedIndex == 2;
                    print(selectedIndex);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
