import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/domain/chat/entities/conversation.dart';
import 'package:tracio_fe/presentation/chat/bloc/bloc/conversation_bloc.dart';
import 'package:tracio_fe/presentation/chat/pages/chat.dart';

class ConversationListItem extends StatelessWidget {
  final ConversationEntity conversation;

  const ConversationListItem({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    // Format the last updated time
    final formattedTime =
        DateFormat('hh:mm a').format(conversation.lastUpdated);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      leading: CircleAvatar(
        radius: 28.w, // Customize the size as needed
        backgroundImage: NetworkImage(
            conversation.userAvatar ?? conversation.groupPicture ?? ''),
      ),
      title: Text(
        conversation.isGroup
            ? (conversation.groupName ?? 'Group')
            : (conversation.userName ?? ''),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        conversation.latestMessage ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: conversation.isRead ? Colors.grey[600] : Colors.black87,
            fontWeight:
                conversation.isRead ? FontWeight.w400 : FontWeight.w600),
      ),
      trailing: Text(
        formattedTime,
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      ),
      onTap: () {
        AppNavigator.push(
          context,
          BlocProvider.value(
            value: context.read<ConversationBloc>()
              ..add(GetMessages(conversationId: conversation.conversationId)),
            child: ChatPage(
                conversationId: conversation.conversationId,
                conversation: conversation),
          ),
        );
      },
    );
  }
}
