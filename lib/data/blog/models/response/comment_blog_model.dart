// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:tracio_fe/domain/blog/entites/comment_blog.dart';

import '../../../../common/helper/media_file.dart';

class CommentBlogModel extends CommentBlogEntity {
  CommentBlogModel(
      {required super.commentId,
      required super.userId,
      required super.userName,
      required super.avatar,
      required super.content,
      required super.createdAt,
      required super.likesCount,
      required super.isReacted,
      required super.repliesCount,
      required super.mediaFiles});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'cyclistId': userId,
      'cyclistName': userName,
      'cyclistAvatar': avatar,
      'content': content,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'likesCount': likesCount,
      'isReacted': isReacted,
      'mediaFiles': mediaFiles
    };
  }

  factory CommentBlogModel.fromMap(Map<String, dynamic> map) {
    return CommentBlogModel(
        commentId: map['commentId'] != null ? map['commentId'] as int : null,
        userId: map['cyclistId'] != null ? map['cyclistId'] as int : null,
        userName:
            map['cyclistName'] != null ? map['cyclistName'] as String : null,
        avatar: map['cyclistAvatar'] != null
            ? map['cyclistAvatar'] as String
            : null,
        content: map['content'] != null ? map['content'] as String : null,
        createdAt: DateTime.tryParse(map["createdAt"] ?? ""),
        likesCount: map['likesCount'] as int,
        isReacted: map['isReacted'],
        repliesCount: map['repliesCount'] as int,
        mediaFiles: map["mediaFiles"] == null
            ? []
            : List<MediaFile>.from(
                map["mediaFiles"]!.map((x) => MediaFile.fromJson(x))));
  }

  String toJson() => json.encode(toMap());

  factory CommentBlogModel.fromJson(String source) =>
      CommentBlogModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
