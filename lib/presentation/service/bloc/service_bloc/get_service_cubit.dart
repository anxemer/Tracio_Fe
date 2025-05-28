import 'package:Tracio/domain/shop/entities/response/shop_service_entity.dart';
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

  void getMoreService() async {
    final currentState = state;

    if (currentState is GetServiceLoaded) {
      try {
        final nextPage = currentState.metaData.pageNumberService! + 1;

        final result = await sl<GetServiceUseCase>().call(
          GetServiceReq(
            pageNumberService: nextPage,
            pageSizeService: currentState.params.pageSizeService,
          ),
        );

        result.fold((error) {
          emit(GetServiceFailure(
            currentState.service,
            currentState.shop,
            currentState.metaData,
            currentState.params,
            error.message,
          ));
        }, (data) {
          final updatedService =
              List<ShopServiceEntity>.from(currentState.service);
          updatedService.addAll(data.service);

          emit(GetServiceLoaded(
            updatedService,
            currentState.shop,
            data.paginationMetaData,
            GetServiceReq(
              pageNumberService: nextPage,
              pageSizeService: currentState.params.pageSizeService,
            ),
          ));
        });
      } catch (e) {
        emit(GetServiceFailure(
          currentState.service,
          currentState.shop,
          currentState.metaData,
          currentState.params,
          e.toString(),
        ));
      }
    }
  }

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
