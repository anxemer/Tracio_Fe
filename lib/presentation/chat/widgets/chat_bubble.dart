import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/domain/chat/entities/message.dart';
import 'package:tracio_fe/presentation/chat/widgets/image_message.dart';
import 'package:tracio_fe/presentation/chat/widgets/shared_message.dart';

class ChatBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isSentByMe;
  final bool isLast;
  final bool isFirst;
  final bool isMiddle;
  final bool isLastMessage;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isSentByMe,
      this.isFirst = false,
      this.isLast = false,
      this.isMiddle = false,
      required this.isLastMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(bottom: 2, left: 8, right: 8, top: isFirst ? 8 : 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isFirst && !isSentByMe) ...[
            Container(
              constraints: BoxConstraints(maxWidth: 150.w),
              child: Padding(
                padding: const EdgeInsets.only(left: 14 * 2 + 8.0, bottom: 4),
                child: Text(
                  message.senderName ?? "Unknown",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isSentByMe) ...[
                if (isLast)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(message.senderAvatar ?? ""),
                      backgroundColor: Colors.grey.shade300,
                    ),
                  )
                else
                  SizedBox(width: 36),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  constraints: BoxConstraints(maxWidth: 250.w),
                  decoration: BoxDecoration(
                    color: isSentByMe ? AppColors.primary : Colors.white,
                    borderRadius: getBubbleRadius(
                      isFirst: isFirst,
                      isMiddle: isMiddle,
                      isLast: isLast,
                      isSentByMe: isSentByMe,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: isSentByMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.content ?? "",
                        style: TextStyle(
                          color: isSentByMe ? Colors.white : Colors.black87,
                        ),
                        softWrap: true,
                      ),
                      if (message.sharedContent != null)
                        SharedMessageWidget(content: message.sharedContent!),
                      if (message.attachments.isNotEmpty)
                        ImageMessage(
                            imageUrl: message.attachments.first.fileUrl)
                    ],
                  ),
                ),
              ),
            ],
          ),
          // if (isLastMessage && isSentByMe) ...[
          //   Padding(
          //     padding: const EdgeInsets.only(top: 2),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         Text(
          //           message.statuses.first.status.name,
          //           style: TextStyle(
          //             color: Colors.grey.shade600,
          //             fontSize: AppSize.textSmall.sp,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }

  BorderRadius getBubbleRadius({
    required bool isFirst,
    required bool isMiddle,
    required bool isLast,
    required bool isSentByMe,
  }) {
    if (isSentByMe) {
      // Sent by me → bubble on right side
      if (isFirst) {
        return BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(5),
        );
      } else if (isMiddle) {
        return BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(5),
        );
      } else if (isLast) {
        return BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        );
      }
    } else {
      if (isFirst) {
        return BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(15),
        );
      } else if (isMiddle) {
        return BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(15),
        );
      } else if (isLast) {
        return BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        );
      }
    }

    // Default (just in case)
    return BorderRadius.circular(15);
  }
}
