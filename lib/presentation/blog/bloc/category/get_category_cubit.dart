import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/blog/usecase/get_category.dart';
import 'package:tracio_fe/presentation/blog/bloc/category/get_category_state.dart';
import 'package:tracio_fe/service_locator.dart';

class GetCategoryCubit extends Cubit<GetCategoryState> {
  GetCategoryCubit() : super(CategoryLoading());

  Future<void> getCategoryBlog() async {
    var returnData = await sl<GetCategoryUseCase>().call(NoParams());
    returnData.fold(
      (error) => emit(CategoryFailure(message: error.toString())),
      (data) => emit(CategoryLoaded(categories: data)),
    );
  }
}
