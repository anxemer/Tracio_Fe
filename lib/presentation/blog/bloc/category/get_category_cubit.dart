import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/blog/usecase/get_category.dart';
import 'package:Tracio/domain/shop/usecase/get_cate_service.dart';
import 'package:Tracio/presentation/blog/bloc/category/get_category_state.dart';
import 'package:Tracio/service_locator.dart';

class GetCategoryCubit extends Cubit<GetCategoryState> {
  GetCategoryCubit() : super(CategoryLoading());

  Future<void> getCategoryBlog() async {
    var returnData = await sl<GetCategoryUseCase>().call(NoParams());
    returnData.fold(
      (error) => emit(CategoryFailure(message: error.toString())),
      (data) => emit(CategoryLoaded(categories: data)),
    );
  }

  Future<void> getCategoryService() async {
    var returnData = await sl<GetCateServiceUseCase>().call(NoParams());
    returnData.fold(
      (error) => emit(CategoryFailure(message: error.toString())),
      (data) => emit(CategoryLoaded(categories: data)),
    );
  }
}
