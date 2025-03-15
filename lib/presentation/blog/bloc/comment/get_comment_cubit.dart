import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/data/blog/models/request/get_comment_req.dart';
import 'package:tracio_fe/domain/blog/usecase/get_comment_blog.dart';
import 'package:tracio_fe/presentation/blog/bloc/comment/get_comment_state.dart';

import '../../../../service_locator.dart';

class GetCommentCubit extends Cubit<GetCommentState> {
  GetCommentCubit() : super(GetCommentLoading());

  Future<void> getCommentBlog(GetCommentReq comment) async {
    emit(GetCommentLoading());
    var result = await sl<GetCommentBlogUseCase>().call(comment);
    result.fold((error) => emit(GetCommentFailure(error)),
        (data) => emit(GetCommentLoaded(listComment: data)));
  }
}
