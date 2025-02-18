import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/blog/animation_react.dart';
import 'package:tracio_fe/common/widget/blog/header_information.dart';
import 'package:tracio_fe/common/widget/blog/picture_card.dart';
import 'package:tracio_fe/data/blog/models/react_blog_req.dart';
import 'package:tracio_fe/domain/blog/entites/blog.dart';
import 'package:tracio_fe/domain/blog/usecase/react_blog.dart';

import '../../../service_locator.dart';
import 'react_blog.dart';

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
    "https://scontent.fsgn5-15.fna.fbcdn.net/v/t39.30808-6/475808610_2055510964890945_6981339981204090445_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=833d8c&_nc_eui2=AeFuzhyv1tGpVw0zdp5FZi2QCmE5p8uTYu8KYTmny5Ni7x0XFZUf_3CjmfFq0ijyHshABIFlon-KuqcJwNodd3tD&_nc_ohc=V5QUgb_JkvcQ7kNvgGFL4sG&_nc_oc=AdhaXFs5ieuQa19m2u6i4PJeQQblTNYG0iGwrgIXeFKgjMxv_bcGxjwI8Mda9s6GJeanabDK6SGc39B07LpXjqDz&_nc_zt=23&_nc_ht=scontent.fsgn5-15.fna&_nc_gid=A0-wGDajTZBpzD1sxzOjQ-q&oh=00_AYAZ-xivIey7xtzADd2Z0Q_V4QibPFLVA_puS3YcTwfdQQ&oe=67B9F8A6",
    "https://scontent.fsgn5-10.fna.fbcdn.net/v/t39.30808-6/475301636_575094608686984_5016456148173086214_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=833d8c&_nc_eui2=AeFThwvZJzHculvQp6XUlQ1ANSMGxnlrtis1IwbGeWu2K1zJ1KU2u-mFJpCVrwmmZIF8FvXl1_CCekeBz5xNRBrn&_nc_ohc=nov_yaNV1cYQ7kNvgE9wgkc&_nc_oc=AdjS2_oxFIrJq5lpE05jh5CkD6zROdS7CAuw_zM3mgTT3TP2aQJNf-0AJ4OHc_Ay9kzv4KCROSZMdUGnNIj0h1ZS&_nc_zt=23&_nc_ht=scontent.fsgn5-10.fna&_nc_gid=AW0gW2GjeJiS5JsCWZqvn4y&oh=00_AYBRw_NDYLEDmr89Lm39fzBt8z8imlBE5iM8SP3uq8HD9w&oe=67B9ECFC",
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
            HeaderInformation(
                title: Text(
                  widget.blogEntity.userName,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 40.sp),
                ),
                imageUrl: Image.network(widget.blogEntity.avatar),
                trailling: Icon(Icons.arrow_forward_ios_rounded)),
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
              onDoubleTap: () async {
                await sl<ReactBlogUseCase>().call(
                    params: ReactBlogReq(
                        entityId: widget.blogEntity.blogId,
                        entityType: "blog"));
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
  }

  // Widget _informationPost() {
  //   return HeaderInformation(title: title, imageUrl: imageUrl, trailling: trailling)
  //   // SizedBox(
  //   //     width: 750.w,
  //   //     height: 100.h,
  //   //     child: Center(
  //   //       child: ListTile(
  //   //         leading: ClipOval(
  //   //           child: Container(
  //   //             decoration:
  //   //                 BoxDecoration(borderRadius: BorderRadius.circular(60.sp)),
  //   //             width: 80.w,
  //   //             // height: 100.h,
  //   //             child: Image.asset(
  //   //               AppImages.man,
  //   //               fit: BoxFit.fill,
  //   //             ),
  //   //           ),
  //   //         ),
  //   //         title: Text(
  //   //           widget.blogEntity.userName.toString(),
  //   //           style: TextStyle(
  //   //               color: Colors.black,
  //   //               fontWeight: FontWeight.w700,
  //   //               fontSize: 28.sp),
  //   //         ),
  //   //         // subtitle: Text(
  //   //         //   'AnXemer',
  //   //         //   style: TextStyle(
  //   //         //       color: Colors.black,
  //   //         //       fontWeight: FontWeight.w400,
  //   //         //       fontSize: 20.sp),
  //   //         // ),
  //   //         trailing: Icon(Icons.arrow_forward_ios_rounded),
  //   //       ),
  //   //     ));
  // }
}
