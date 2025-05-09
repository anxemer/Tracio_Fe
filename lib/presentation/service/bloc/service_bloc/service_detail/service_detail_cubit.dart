import 'package:Tracio/data/shop/models/get_detail_service_req.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/shop/entities/response/detail_service_response_entity.dart';
import 'package:Tracio/domain/shop/usecase/get_service_detail.dart';
import 'package:Tracio/service_locator.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
part 'service_detail_state.dart';

class ServiceDetailCubit extends Cubit<ServiceDetailState> {
  ServiceDetailCubit() : super(ServiceDetailInitial());

  void getServiceDetail(params) async {
    try {
      bg.Location location =
          await bg.BackgroundGeolocation.getCurrentPosition();

      emit(ServiceDetailLoading());
      var result = await sl<GetServiceDetailUseCase>().call(GetDetailServiceReq(
          serviceId: params,
          latitude: location.coords.latitude,
          longitude: location.coords.longitude));
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
