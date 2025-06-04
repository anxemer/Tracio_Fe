import 'package:Tracio/data/auth/sources/auth_local_source/auth_local_source.dart';
import 'package:Tracio/presentation/profile/pages/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/blog/animation_react.dart';
import 'package:Tracio/common/widget/blog/header_information.dart';
import 'package:Tracio/common/widget/blog/picture_card.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/blog/entites/blog_entity.dart';
import 'package:Tracio/domain/user/usecase/follow_user.dart';
import 'package:Tracio/presentation/blog/bloc/comment/comment_input_cubit.dart';
import 'package:Tracio/presentation/blog/pages/detail_blog.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:Tracio/presentation/blog/widget/animated_button_follow.dart';

import '../../../domain/auth/entities/user.dart';
import '../../../service_locator.dart';
import '../bloc/comment/get_comment_cubit.dart';

class PostBlog extends StatefulWidget {
  const PostBlog(
      {super.key,
      required this.blogEntity,
      // required this.onLikeUpdated,
      this.isPersonal = false});
  final BlogEntity blogEntity;
  final bool isPersonal;
  // final Function() onLikeUpdated;
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
    UserEntity? user = sl<AuthLocalSource>().getUser();
    final isOwner = user?.userId == widget.blogEntity.userId;

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
          imageUrl: InkWell(
            onTap: () => AppNavigator.push(
                context,
                UserProfilePage(
                  myProfile: user!.userId == widget.blogEntity.userId,
                  userId: widget.blogEntity.userId,
                )),
            child: CachedNetworkImage(
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
          ),
          trailling: () {
            if (widget.blogEntity.isFollowed) {
              return InkWell(
                  onTap: () => showPostOptions(context, isOwner),
                  child: Icon(Icons.more_vert_outlined));
            } else {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isAlreadyFollowed && _showFollowButton && !isOwner)
                    AnimatedFollowButton(
                      onUnfollow: () {},
                      initiallyFollowed: false,
                      initialFillColor: Colors.transparent,
                      onFollow: _handleFollowLogic,
                      initialTextColor: !isDark ? Colors.black87 : Colors.white,
                      width: 80.w,
                      height: 30.h,
                    ),
                  InkWell(
                      onTap: () => showPostOptions(context, isOwner),
                      child: Icon(Icons.more_vert_outlined))
                ],
              );
            }

            // Trường hợp là chủ sở hữu, không hiển thị gì thêm
          }(),
        ),
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
                BlocProvider(
                  create: (context) =>
                      CommentInputCubit.forBlog(widget.blogEntity.blogId),
                  child: BlocProvider.value(
                    value: context.read<GetCommentCubit>(),
                    child: DetailBlogPage(
                      userId: user!.userId!,
                      blog: widget.blogEntity,
                    ),
                  ),
                )),
            // onDoubleTap: () async {
            //   await sl<ReactBlogUseCase>().call(ReactBlogReq(
            //       entityId: widget.blogEntity.blogId, entityType: "blog"));
            //   setState(() {
            //     widget.blogEntity.likesCount++;
            //     widget.blogEntity.isReacted = true;
            //     isAnimating = true;
            //   });
            //   widget.onLikeUpdated();
            // },
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

  void showPostOptions(BuildContext context, bool isOwner) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isOwner
                  ? _buildOption(context, Icons.edit, 'Edit', () {
                      Navigator.pop(context);
                      // handle edit
                    })
                  : SizedBox.shrink(),
              isOwner
                  ? _buildOption(context, Icons.delete, 'Delete', () {
                      Navigator.pop(context);
                      // handle delete
                    })
                  : SizedBox.shrink(),
              _buildOption(context, Icons.bookmark_add_outlined, 'Save', () {
                Navigator.pop(context);
                // handle save
              }),
              _buildOption(
                  context, Icons.report_gmailerrorred_rounded, 'Report', () {
                Navigator.pop(context);
                showReportReasons(context); // chuyển sang popup ảnh 2
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  void showReportReasons(BuildContext context) {
    final reasons = [
      'I just don\'t like it',
      'Bullying or unwanted contact',
      'Suicide, self-injury or eating disorders',
      'Violence, hate or exploitation',
      'Selling or promoting restricted items',
      'Nudity or sexual activity',
      'Scam, fraud or spam',
      'False information',
      'Intellectual property',
    ];

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Why are you reporting this post?',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              ...reasons.map((reason) => ListTile(
                    title: Text(reason, style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      // handle report reason
                    },
                  )),
            ],
          ),
        );
      },
    );
  }
}
