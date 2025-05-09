import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/usecase/usecase.dart';
import 'generic_data_state.dart';

class GenericDataCubit extends Cubit<GenericDataState> {
  GenericDataCubit() : super(DataLoading());

  void getData<T>(Usecase usecase, {dynamic params}) async {
    var returnedData = await usecase.call(params);
    returnedData.fold((error) {
      emit(FailureLoadData(errorMessage: error.message, error));
    }, (data) {
      emit(DataLoaded<T>(data: data));
    });
  }
}
