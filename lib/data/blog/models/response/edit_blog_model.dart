// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EditBlogModel {
  final int bloId;
  final String context;
  final bool isPublic;

  EditBlogModel(
    this.bloId,
    this.context,
    this.isPublic,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'blogId': bloId,
      'context': context,
      'isPublic': isPublic,
    };
  }

  factory EditBlogModel.fromMap(Map<String, dynamic> map) {
    return EditBlogModel(
      map['blogId'] as int,
      map['context'] as String,
      map['isPublic'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory EditBlogModel.fromJson(String source) =>
      EditBlogModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
