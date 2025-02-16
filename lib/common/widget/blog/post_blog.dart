import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/blog/animation_react.dart';
import 'package:tracio_fe/common/widget/blog/picture_card.dart';
import 'package:tracio_fe/domain/blog/entites/blog.dart';

import '../../../core/configs/theme/assets/app_images.dart';
import '../../../presentation/blog/widget/react_blog.dart';

class PostBlog extends StatefulWidget {
  const PostBlog({super.key, required this.blogEntity, this.morewdget});
  final BlogEntity blogEntity;
  final Widget? morewdget;

  @override
  State<PostBlog> createState() => _PostBlogState();
}

class _PostBlogState extends State<PostBlog> {
  bool isAnimating = false;
  final List<String> listImageUrl = [
    "https://cdn.oneesports.vn/cdn-data/sites/4/2023/10/DragonBallDaima_Goku.jpg",
    "https://cdn1.tuoitre.vn/thumb_w/1200/471584752817336320/2024/12/7/mv5bmdyxzdk4nwmtmddjns00mdizlwiwzjqtyjixntu3owvkzguxxkeyxkfqcgdeqxryyw5zy29kzs13b3jrzmxvdwv1-17335126932221404416032-28-0-1033-1920-crop-17335135443091347309733.jpg",
    "https://static.minhtuanmobile.com/uploads/editer/2024-10/12/images/giai-thich-dong-thoi-gian-cua-dragon-ball-daima-1.webp"
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.lightBlueAccent.withValues(alpha: .1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _informationPost(),
            SizedBox(
              height: 16.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.blogEntity.content.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  isAnimating = true;
                });
              },
              child: Stack(alignment: Alignment.center, children: [
                PictureCard(
                  listImageUrl: listImageUrl,
                ),
                AnimatedOpacity(
                  opacity: isAnimating ? 1 : 0,
                  duration: Duration(microseconds: 200),
                  child: AnimationReact(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red.shade600,
                      size: 100.w,
                    ),
                    isAnimating: isAnimating,
                    duration: Duration(milliseconds: 400),
                    iconlike: false,
                    End: () {
                      setState(() {
                        isAnimating = false;
                      });
                    },
                  ),
                )
              ]),
            ),
            // _reactBlog(),
            ReactBlog(
              blogEntity: widget.blogEntity,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: Text(
            //     'view all 200 comments',
            //     style: TextStyle(
            //         color: Colors.black54,
            //         fontSize: 24.sp,
            //         fontWeight: FontWeight.w500),
            //   ),
            // ),
            widget.morewdget ?? Container()
          ],
        ),
      ),
    );
    ;
  }

  Widget _informationPost() {
    return SizedBox(
        width: 750.w,
        height: 100.h,
        child: Center(
          child: ListTile(
            leading: ClipOval(
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(60.sp)),
                width: 80.w,
                // height: 100.h,
                child: Image.asset(
                  AppImages.man,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Text(
              widget.blogEntity.userName.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 28.sp),
            ),
            // subtitle: Text(
            //   'AnXemer',
            //   style: TextStyle(
            //       color: Colors.black,
            //       fontWeight: FontWeight.w400,
            //       fontSize: 20.sp),
            // ),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
          ),
        ));
  }
}
