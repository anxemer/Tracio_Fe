import 'package:bloc/bloc.dart';

import 'package:Tracio/domain/shop/entities/response/pagination_service_data_entity.dart';
import 'package:Tracio/domain/shop/usecase/get_service.dart';

import '../../../../data/shop/models/get_service_req.dart';
import '../../../../service_locator.dart';
import 'get_service_state.dart';

class GetServiceCubit extends Cubit<GetServiceState> {
  GetServiceCubit()
      : super(GetServiceInitial([], [], PaginationServiceDataEntity(),
            GetServiceReq(pageNumberService: 1, pageSizeService: 10)));

  void getService(GetServiceReq params) async {
    try {
      emit(GetServiceLoading(
          state.service, state.shop, state.metaData, state.params));
      var resultData = await sl<GetServiceUseCase>().call(params);
      resultData.fold((error) {
        emit(GetServiceFailure(
            state.service, state.shop, state.metaData, params, error.message));
      }, (data) {

        emit(GetServiceLoaded(
            data.service, data.shop, data.paginationMetaData, params));
      });
    } catch (e) {
      emit(GetServiceFailure(
          state.service, state.shop, state.metaData, params, e.toString()));
    }
  }

  void getMoreService(GetServiceReq params) async {}


  void resetState() {
    emit(GetServiceInitial(
        [],
        [],
        PaginationServiceDataEntity(),
        GetServiceReq(
            pageNumberService: 1,
            pageSizeService: 10))); // Reset về trạng thái ban đầu
  }
}
