import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/domain/blog/usecase/get_blogs.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_state.dart';

import '../../../data/blog/models/get_blog_req.dart';
import '../../../service_locator.dart';

class GetBlogCubit extends Cubit<GetBlogState> {
  GetBlogCubit() : super(GetBlogLoading());

  Future<void> getBlog() async {
    var returnedData = await sl<GetBlogsUseCase>().call();

    returnedData.fold((error) {
      emit(GetBlogFailure(errorMessage: error));
    }, (data) {
      emit(GetBlogLoaded(listBlog: data));
    });
  }
}
