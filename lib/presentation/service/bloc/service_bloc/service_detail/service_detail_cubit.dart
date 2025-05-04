import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/domain/shop/entities/response/detail_service_response_entity.dart';
import 'package:tracio_fe/domain/shop/usecase/get_service_detail.dart';
import 'package:tracio_fe/service_locator.dart';

part 'service_detail_state.dart';

class ServiceDetailCubit extends Cubit<ServiceDetailState> {
  ServiceDetailCubit() : super(ServiceDetailInitial());

  void getServiceDetail(params) async {
    try {
      emit(ServiceDetailLoading());
      var result = await sl<GetServiceDetailUseCase>().call(params);
      result.fold((error) {
        emit(ServiceDetailFailure(error.message, error));
      }, (data) {
        emit(ServiceDetailLoaded(data));
      });
    } on Failure catch (e) {
      emit(ServiceDetailFailure(e.toString(), e));
    }
  }
}
