// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:tracio_fe/common/widget/blog/comment/comment_widget.dart';
import 'package:tracio_fe/common/widget/blog/comment/first_respondent_widget.dart';

typedef AvatarWidgetBuilder<T> = PreferredSize Function(
  BuildContext context,
  T value,
);

typedef ContentBuilder<T> = Widget Function(BuildContext context, T value);

class CommentTreeWidget<C, R> extends StatefulWidget {
  final C comment;
  final List<R> replies;

  final AvatarWidgetBuilder<C>? avatarComment;
  final AvatarWidgetBuilder<R>? avatarReply;

  final ContentBuilder<C>? commentContent;
  final ContentBuilder<R>? replyContent;

  final double lineWidth;
  final Color lineColor;

  const CommentTreeWidget(
      {super.key,
      required this.comment,
      required this.replies,
      required this.avatarComment,
      required this.avatarReply,
      required this.commentContent,
      required this.replyContent,
      this.lineWidth = 2.0,
      this.lineColor = Colors.grey});

  @override
  // ignore: library_private_types_in_public_api
  _CommentTreeWidgetState<C, R> createState() =>
      _CommentTreeWidgetState<C, R>();
}

class _CommentTreeWidgetState<C, R> extends State<CommentTreeWidget<C, R>> {
  bool isFirstReplyRevealed = false;
  bool isSecondReplyRevealed = false;
  @override
  Widget build(BuildContext context) {
    final PreferredSize avatarRoot =
        widget.avatarComment!(context, widget.comment);

    return Column(
      children: [
        CommentWidget(
          avatar: avatarRoot,
          hasChild: widget.replies.isNotEmpty,
          content: widget.commentContent!(context, widget.comment),
          lineColor: widget.lineColor,
          lineWidth: widget.lineWidth,
        ),
        ...widget.replies.asMap().entries.map(
          (entry) {
            final int replyIndex = entry.key;
            final reply = entry.value;
            return FirstRespondentWidget(
              isLast: replyIndex == (widget.replies.length - 1),
              avatar: widget.avatarReply!(context, reply),
              avatarRoot: avatarRoot.preferredSize,
              content: widget.replyContent!(context, reply),
              lineColor: widget.lineColor,
              lineWidth: widget.lineWidth,
            );
          },
        ),
      ],
    );
  }
}
