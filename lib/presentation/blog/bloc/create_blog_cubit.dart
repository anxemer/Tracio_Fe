import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/data/blog/models/create_blog_req.dart';
import 'package:tracio_fe/domain/blog/usecase/craete_blog.dart';
import 'package:tracio_fe/presentation/blog/bloc/create_blog_state.dart';

import '../../../service_locator.dart';

class CreateBlogCubit extends Cubit<CreateBlogState> {
  CreateBlogCubit() : super(CreateBlogInittial(message: 'Creating'));

  void CreateBlog(CreateBlogReq param) async {
    try {
      emit(CreateBlogLoading());

      final result = await sl<CreateBlogUseCase>().call(params: param);
      result.fold((erorr) {
        emit(CreateBlogFail(error: erorr));
      }, (data) {
        emit(CreateBlogSuccess());
      });
    } catch (e) {
      emit(CreateBlogFail(error: e.toString()));
    }
  }
}
