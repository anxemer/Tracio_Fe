import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/chat/entities/conversation.dart';

class ChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  final ConversationEntity conversation;

  const ChatAppbar({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final String? avatarUrl = conversation.isGroup
        ? conversation.groupPicture
        : conversation.userAvatar;

    final String name = conversation.isGroup
        ? conversation.groupName ?? 'Group'
        : conversation.userName ?? 'User';

    return BasicAppbar(
      height: AppSize.appBarHeight.h,
      title: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 16.w,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child: avatarUrl == null
                ? Icon(Icons.person, size: 14.w, color: Colors.grey)
                : null,
          ),
          SizedBox(width: 8.0.w),

          // Name
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: AppSize.textHeading * 0.7.sp,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Icon(Icons.more_vert_sharp, color: Colors.white)
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppSize.appBarHeight.h);
}
