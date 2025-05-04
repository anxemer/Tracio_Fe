import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/blog/animation_react.dart';
import 'package:tracio_fe/common/widget/blog/header_information.dart';
import 'package:tracio_fe/common/widget/blog/picture_card.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/blog/models/request/react_blog_req.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/domain/blog/usecase/react_blog.dart';
import 'package:tracio_fe/domain/user/usecase/follow_user.dart';
import 'package:tracio_fe/presentation/blog/pages/detail_blog.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tracio_fe/presentation/blog/widget/animated_button_follow.dart';

import '../../../service_locator.dart';
import '../bloc/comment/get_comment_cubit.dart';
import '../pages/edit_blog.dart';

class PostBlog extends StatefulWidget {
  const PostBlog(
      {super.key,
      required this.blogEntity,
      this.onLikeUpdated,
      this.isPersonal = false});
  final BlogEntity blogEntity;
  final bool isPersonal;
  final Function()? onLikeUpdated;
  @override
  State<PostBlog> createState() => _PostBlogState();
}

class _PostBlogState extends State<PostBlog> {
  bool isAnimating = false;
  bool _showFollowButton = true;
  bool isAlreadyFollowed = false; // Lấy từ state/dữ liệu thực tế

  void _handleFollowLogic() async {
    await sl<FollowUserUseCase>().call(widget.blogEntity.userId);
    setState(() {
      isAlreadyFollowed = true;
    });
    // setState(() { isAlreadyFollowed = true; }); // Ví dụ cập nhật UI ngay lập tức (tùy logic)
  }

  @override
  void initState() {
    isAlreadyFollowed = widget.blogEntity.isFollowed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    List<String> mediaUrls = widget.blogEntity.mediaFiles
        .map((file) => file.mediaUrl ?? "")
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderInformation(
            title: Text(
              widget.blogEntity.userName,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: AppSize.textLarge.sp),
            ),
            subtitle: Text(
              timeago.format(widget.blogEntity.createdAt!),
              style: TextStyle(fontSize: AppSize.textSmall.sp),
            ),
            imageUrl: CachedNetworkImage(
              imageUrl: widget.blogEntity.avatar,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                // radius: 30.sp,
                backgroundImage: imageProvider,
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                radius: AppSize.imageSmall / 2.w,
                child: Icon(
                  Icons.person,
                  size: AppSize.imageSmall / 2.w,
                ),
              ),
            ),
            trailling: widget.isPersonal
                ? PopupMenuButton<int>(
                    icon:
                        Icon(Icons.more_vert), // hoặc bất kỳ icon nào bạn muốn
                    onSelected: (int result) {
                      if (result == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditBlogPostScreen(
                                    imageUrl: widget.blogEntity.mediaFiles,
                                    blogId: widget.blogEntity.blogId,
                                    initialContent: widget.blogEntity.content,
                                    initialIsPublic: widget.blogEntity.isPublic,
                                  )),
                        );
                      } else if (result == 1) {
                        // handle delete
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<int>>[
                      PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.black),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isAlreadyFollowed && _showFollowButton)
                        AnimatedFollowButton(
                          initialFillColor: Colors.transparent,
                          onFollow: _handleFollowLogic,
                          initialTextColor:
                              !isDark ? Colors.black87 : Colors.white,
                          width: 80.w,
                          height: 30.h,
                        )
                      // else if (isAlreadyFollowed)
                      //   const Text(
                      //       "Followed") // Hoặc ButtonDesign với trạng thái "Unfollow"
                    ],
                  )),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            widget.blogEntity.content.toString(),
            style: TextStyle(
                color: context.isDarkMode ? Colors.white : Colors.black,
                fontSize: AppSize.textMedium.sp,
                fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        GestureDetector(
            onTap: () => AppNavigator.push(
                context,
                BlocProvider.value(
                  value: context.read<GetCommentCubit>(),
                  child: DetailBlocPage(
                    blog: widget.blogEntity,
                  ),
                )),
            onDoubleTap: () async {
              await sl<ReactBlogUseCase>().call(ReactBlogReq(
                  entityId: widget.blogEntity.blogId, entityType: "blog"));
              setState(() {
                widget.blogEntity.likesCount++;
                widget.blogEntity.isReacted = true;
                isAnimating = true;
              });
              widget.onLikeUpdated;
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
                          size: 44.sp,
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
    );
  }
}
