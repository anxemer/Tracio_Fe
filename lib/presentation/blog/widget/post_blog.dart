import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/blog/animation_react.dart';
import 'package:tracio_fe/common/widget/blog/header_information.dart';
import 'package:tracio_fe/common/widget/blog/picture_card.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/blog/models/request/react_blog_req.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/domain/blog/usecase/react_blog.dart';
import 'package:tracio_fe/presentation/blog/pages/detail_blog.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../service_locator.dart';

class PostBlog extends StatefulWidget {
  const PostBlog({super.key, required this.blogEntity, this.onLikeUpdated});
  final BlogEntity blogEntity;
  final Function()? onLikeUpdated;
  @override
  State<PostBlog> createState() => _PostBlogState();
}

class _PostBlogState extends State<PostBlog> {
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    List<String> mediaUrls = widget.blogEntity.mediaFiles
        .map((file) => file.mediaUrl ?? "")
        .toList();

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 1.h,
              color: Colors.black38,
            ),
            HeaderInformation(
              // widthImage: 70.w,
              title: Text(
                widget.blogEntity.userName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.sp),
              ),
              subtitle: Text(
                timeago.format(widget.blogEntity.createdAt!, locale: 'vi'),
                style: TextStyle(fontSize: 20.sp),
              ),
              imageUrl: CachedNetworkImage(
                imageUrl: widget.blogEntity.avatar,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  // radius: 30.sp,
                  backgroundImage: imageProvider,
                ),
                // maxHeightDiskCache: 200,
                // maxWidthDiskCache: 200,
              ),
              // Image.network(widget.blogEntity.avatar),
              // trailling: GestureDetector(
              //     onTap: () => AppNavigator.push(
              //         context,
              //         DetailBlocPage(
              //           blog: widget.blogEntity,
              //         )),
              //     child: Icon(Icons.arrow_forward_ios_rounded)),
            ),
            SizedBox(
              height: 16.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                widget.blogEntity.content.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
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
                        entityId: widget.blogEntity.blogId,
                        entityType: "blog"));
                    setState(() {
                      widget.blogEntity.likesCount++;
                      widget.blogEntity.isReacted = true;
                      isAnimating = true;
                    });
                    widget.onLikeUpdated;
                  }
                },
                child: mediaUrls.isNotEmpty
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
                              size: AppSize.iconLarge.w,
                            ),
                          ),
                        )
                      ])
                    : Container()),
            // _reactBlog(),
            // ReactBlog(
            //   blogEntity: widget.blogEntity,
            // ),

            // widget.morewdget ?? Container()
          ],
        ));
  }
}
