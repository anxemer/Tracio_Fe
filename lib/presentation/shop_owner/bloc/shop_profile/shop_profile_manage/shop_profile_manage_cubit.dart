import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:tracio_fe/core/erorr/exception.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/domain/shop/usecase/edit_shop.dart';
import 'package:tracio_fe/domain/shop/usecase/register_shop_profile.dart';
import 'package:tracio_fe/service_locator.dart';

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
