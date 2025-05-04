// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReplyReviewReq {
  final int reviewId;
  final String content;
  ReplyReviewReq({
    required this.reviewId,
    required this.content,
  });

  ReplyReviewReq copyWith({
    int? reviewId,
    String? content,
  }) {
    return ReplyReviewReq(
      reviewId: reviewId ?? this.reviewId,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reviewId': reviewId,
      'content': content,
    };
  }

  factory ReplyReviewReq.fromMap(Map<String, dynamic> map) {
    return ReplyReviewReq(
      reviewId: map['reviewId'] as int,
      content: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReplyReviewReq.fromJson(String source) => ReplyReviewReq.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ReplyReviewReq(reviewId: $reviewId, content: $content)';

  @override
  bool operator ==(covariant ReplyReviewReq other) {
    if (identical(this, other)) return true;
  
    return 
      other.reviewId == reviewId &&
      other.content == content;
  }

  @override
  int get hashCode => reviewId.hashCode ^ content.hashCode;
}
