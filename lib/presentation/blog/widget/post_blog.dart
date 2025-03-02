import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/bloc/generic_data_cubit.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/blog/animation_react.dart';
import 'package:tracio_fe/common/widget/blog/header_information.dart';
import 'package:tracio_fe/common/widget/blog/picture_card.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/data/blog/models/request/get_comment_req.dart';
import 'package:tracio_fe/data/blog/models/request/react_blog_req.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';
import 'package:tracio_fe/domain/blog/usecase/get_reply_comment.dart';
import 'package:tracio_fe/domain/blog/usecase/react_blog.dart';
import 'package:tracio_fe/presentation/blog/bloc/comment/get_commnet_cubit.dart';
import 'package:tracio_fe/presentation/blog/pages/detail_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    List<String> mediaUrls = widget.blogEntity.mediaFiles
        .map((file) => file.mediaUrl ?? "")
        .toList();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetCommentCubit(),
        ),
       
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 1.h,
              color: Colors.black38,
            ),
            HeaderInformation(
                title: Text(
                  widget.blogEntity.userName,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 40.sp),
                ),
                subtitle: Text(
                  timeago.format(widget.blogEntity.createdAt!, locale: 'vi'),
                  style: TextStyle(fontSize: 20.sp),
                ),
                imageUrl: Image.asset(AppImages.man),
                // Image.network(widget.blogEntity.avatar),
                trailling: GestureDetector(
                    onTap: () => AppNavigator.push(context, DetailBlocPage()),
                    child: Icon(Icons.arrow_forward_ios_rounded))),
            SizedBox(
              height: 16.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                widget.blogEntity.content.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            GestureDetector(
              onDoubleTap: () async {
                if (widget.blogEntity.isReacted == false) {
                  await sl<ReactBlogUseCase>().call(ReactBlogReq(
                      entityId: widget.blogEntity.blogId, entityType: "blog"));
                  setState(() {
                    widget.blogEntity.likesCount++;
                    widget.blogEntity.isReacted = true;
                    isAnimating = true;
                  });
                }
              },
              child: mediaUrls != []
                  ? Stack(alignment: Alignment.center, children: [
                      PictureCard(listImageUrl: mediaUrls),
                      AnimatedOpacity(
                        opacity: isAnimating ? 1 : 0,
                        duration: Duration(microseconds: 100),
                        child: AnimationReact(
                          isAnimating: isAnimating,
                          duration: Duration(milliseconds: 400),
                          iconlike: false,
                          End: () {
                            setState(() {
                              isAnimating = false;
                            });
                          },
                          child: Icon(
                            Icons.favorite,
                            color: const Color.fromARGB(255, 242, 81, 78),
                            size: 150.w,
                          ),
                        ),
                      )
                    ])
                  : Container(),
            ),
            // _reactBlog(),
            ReactBlog(
              blogEntity: widget.blogEntity,
            ),

            widget.morewdget ?? Container()
          ],
        ),
      ),
    );
  }
}
