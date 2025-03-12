import 'package:equatable/equatable.dart';

import '../../../../domain/blog/entites/comment_input_data.dart';

class CommentInputState extends Equatable {
  final CommentInputData inputData;

  const CommentInputState({
    required this.inputData,
  });

  @override
  List<Object?> get props => [
        inputData.mode,
        inputData.blogId,
        inputData.commentId,
        inputData.replyId
      ];

  CommentInputState copyWith({
    CommentInputData? inputData,
  }) {
    return CommentInputState(
      inputData: inputData ?? this.inputData,
    );
  }
}
