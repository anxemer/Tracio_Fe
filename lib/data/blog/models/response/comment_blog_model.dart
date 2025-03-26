// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:tracio_fe/domain/blog/entites/comment_blog.dart';

import '../../../../common/helper/media_file.dart';

List<CommentBlogModel> commentBlogModelListFromRemoteJson(String str) =>
    List<CommentBlogModel>.from(json
        .decode(str)['result']['blog']['comments']
        .map((x) => CommentBlogModel.fromJson(x)));

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
      'userId': userId,
      'userName': userName,
      'avatar': avatar,
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
        userId: map['userId'] != null ? map['userId'] as int : null,
        userName: map['userName'] != null ? map['userName'] as String : null,
        avatar: map['avatar'] != null ? map['avatar'] as String : null,
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
