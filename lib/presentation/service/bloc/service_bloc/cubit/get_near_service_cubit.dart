import 'package:equatable/equatable.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
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
      bg.Location location =
          await bg.BackgroundGeolocation.getCurrentPosition();

      emit(GetNearServiceLoading(state.service, state.shop));
      var resultData = await sl<GetServiceUseCase>().call(GetServiceReq(
          latitude: location.coords.latitude,
          longitude: location.coords.longitude,
          distance: 100));
      resultData.fold((error) {
        emit(GetNearServiceFailure(
          state.service,
          error.toString(),
          state.shop,
        ));
      }, (data) {
        emit(GetNearServiceLoaded(data.service, data.shop));
      });
    } catch (e) {
      emit(GetNearServiceFailure(
        state.service,
        e.toString(),
        state.shop,
      ));
    }
  }
}
