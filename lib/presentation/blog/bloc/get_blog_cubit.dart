import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/blog/usecase/get_blogs.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_state.dart';

import '../../../data/blog/models/request/get_blog_req.dart';
import '../../../service_locator.dart';

class GetBlogCubit extends Cubit<GetBlogState> {
  GetBlogCubit() : super(GetBlogLoading());

  Future<void> getBlog() async {
    var returnedData = await sl<GetBlogsUseCase>().call(NoParams());

    returnedData.fold((error) {
      emit(GetBlogFailure(errorMessage: error.message));
    }, (data) {
      emit(GetBlogLoaded(listBlog: data));
    });
  }
}
