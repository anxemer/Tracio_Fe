import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/configs/theme/assets/app_images.dart';

class ChooseAudienceBlog extends StatefulWidget {
  ChooseAudienceBlog({super.key, required this.selectedIndex});
  int? selectedIndex;

  @override
  State<ChooseAudienceBlog> createState() => _ChooseAudienceBlogState();
}

class _ChooseAudienceBlogState extends State<ChooseAudienceBlog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        data: widget.selectedIndex,
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
                  shape: const CircleBorder(),
                  value: widget.selectedIndex == 1,
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.selectedIndex = newValue == true ? 1 : null;
                      widget.selectedIndex == 1;
                    });
                  }),
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
                value: widget.selectedIndex == 0,
                onChanged: (bool? newValue) {
                  print(widget.selectedIndex);

                  setState(() {
                    widget.selectedIndex = newValue == true ? 0 : null;
                    widget.selectedIndex == 0;
                  });
                },
              ),
            ),
            // ListTile(
            //   leading: Image.asset(
            //     AppImages.follower,
            //     width: 40,
            //   ), // Ảnh tiêu đề
            //   title: const Text('Follower Only'),
            //   trailing: Checkbox(
            //     checkColor: Colors.black,
            //     activeColor: Colors.white,
            //     shape: const CircleBorder(), // Làm checkbox hình tròn
            //     value: widget.selectedIndex == 2,
            //     onChanged: (bool? newValue) {
            //       setState(() {
            //         widget.selectedIndex = newValue == true ? 2 : null;
            //         widget.selectedIndex == 2;
            //       });
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
