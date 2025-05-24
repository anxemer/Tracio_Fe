import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/services/location/location_service.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/shop/models/get_service_req.dart';
import '../../../../../domain/shop/entities/response/shop_entity.dart';
import '../../../../../domain/shop/entities/response/shop_service_entity.dart';
import '../../../../../domain/shop/usecase/get_service.dart';
import '../../../../../service_locator.dart';

part 'get_near_service_state.dart';

class GetNearServiceCubit extends Cubit<GetNearServiceState> {
  GetNearServiceCubit() : super(GetNearServiceInitial([], []));

  void getNearShop() async {
    try {
      final origin = await sl<LocationService>().getCurrentLocation();
      emit(GetNearServiceLoading(state.service, state.shop));
      var resultData = await sl<GetServiceUseCase>().call(GetServiceReq(
          latitude: origin!.latitude,
          longitude: origin.longitude,
          distance: 100));
      resultData.fold((error) {
        emit(GetNearServiceFailure(
            state.service, error.toString(), state.shop, error));
      }, (data) {
        emit(GetNearServiceLoaded(data.service, data.shop));
      });
    } on ExceptionFailure catch (e) {
      emit(GetNearServiceFailure(state.service, e.toString(), state.shop, e));
    }
  }
}
