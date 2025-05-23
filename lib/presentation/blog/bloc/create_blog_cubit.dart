import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/data/blog/models/request/create_blog_req.dart';
import 'package:Tracio/domain/blog/usecase/craete_blog.dart';
import 'package:Tracio/presentation/blog/bloc/create_blog_state.dart';

import '../../../service_locator.dart';

class CreateBlogCubit extends Cubit<CreateBlogState> {
  CreateBlogCubit() : super(CreateBlogInittial(message: 'Creating'));

  void CreateBlog(CreateBlogReq param) async {
    try {
      emit(CreateBlogLoading());

      final result = await sl<CreateBlogUseCase>().call(param);
      result.fold((erorr) {
        emit(CreateBlogFail(error: erorr.message));
      }, (data) {
        emit(CreateBlogSuccess());
      });
    } catch (e) {
      emit(CreateBlogFail(error: e.toString()));
    }
  }
}
