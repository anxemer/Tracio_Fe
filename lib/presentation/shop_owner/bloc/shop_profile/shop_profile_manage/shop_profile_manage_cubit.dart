import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:Tracio/core/erorr/exception.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/shop/usecase/edit_shop.dart';
import 'package:Tracio/domain/shop/usecase/register_shop_profile.dart';
import 'package:Tracio/service_locator.dart';

import '../../../../../domain/map/entities/place.dart';

part 'shop_profile_manage_state.dart';

class ShopProfileManageCubit extends Cubit<ShopProfileManageState> {
  ShopProfileManageCubit() : super(ShopProfileManageInitial());

  Future<void> registerShop(params) async {
    try {
      emit(ShopProfileManageLoading());
      var result = await sl<RegisterShopUseCase>().call(params);
      result.fold((error) {
        emit(ShopProfileManageFailure(error, error.message));
      }, (data) {
        emit(ShopProfileManageSuccess(data));
      });
    } on ExceptionFailure catch (e) {
      emit(ShopProfileManageFailure(e, e.toString()));
    }
  }

  Future<void> editShop(params) async {
    try {
      emit(ShopProfileManageLoading());
      var result = await sl<EditShopUseCase>().call(params);
      result.fold((error) {
        emit(ShopProfileManageFailure(error, error.message));
      }, (data) {
        emit(ShopProfileManageSuccess(data));
      });
    } on ExceptionFailure catch (e) {
      emit(ShopProfileManageFailure(e, e.toString()));
    }
  }
}
