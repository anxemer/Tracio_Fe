import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracio_fe/domain/shop/usecase/create_service.dart';
import 'package:tracio_fe/domain/shop/usecase/delete_service.dart';

import '../../../../core/erorr/failure.dart';
import '../../../../service_locator.dart';

part 'service_management_state.dart';

class ServiceManagementCubit extends Cubit<ServiceManagementState> {
  ServiceManagementCubit() : super(ServiceManagementInitial());

  void createService(params) async {
    emit(CreateServiceLoading());
    var result = await sl<CreateServiceUseCase>().call(params);
    result.fold((error) {
      emit(CreateServiceFailure(error.message, error));
    }, (data) {
      emit(CreateServiceSuccess());
    });
  }

  void deleteService(param) async {
    var result = await sl<DeleteServiceUseCase>().call(param);
    result.fold((error) {
      emit(CreateServiceFailure(error.message, error));
    }, (data) {
      emit(CreateServiceSuccess());
    });
  }
}
