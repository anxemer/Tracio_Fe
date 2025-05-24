import 'package:Tracio/core/services/location/location_service.dart';
import 'package:Tracio/data/shop/models/get_detail_service_req.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/shop/entities/response/detail_service_response_entity.dart';
import 'package:Tracio/domain/shop/usecase/get_service_detail.dart';
import 'package:Tracio/service_locator.dart';

part 'service_detail_state.dart';

class ServiceDetailCubit extends Cubit<ServiceDetailState> {
  ServiceDetailCubit() : super(ServiceDetailInitial());

  void getServiceDetail(params) async {
    try {
      final origin = await sl<LocationService>().getCurrentLocation();

      emit(ServiceDetailLoading());
      var result = await sl<GetServiceDetailUseCase>().call(GetDetailServiceReq(
          serviceId: params,
          latitude: origin!.latitude,
          longitude: origin.longitude));
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
