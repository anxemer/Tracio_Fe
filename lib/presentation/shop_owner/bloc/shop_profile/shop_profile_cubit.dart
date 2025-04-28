import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/shop/entities/response/shop_profile_entity.dart';
import 'package:tracio_fe/domain/shop/usecase/get_shop_profile.dart';

import '../../../../service_locator.dart';

part 'shop_profile_state.dart';

class ShopProfileCubit extends Cubit<ShopProfileState> {
  ShopProfileCubit() : super(ShopProfileInitial());

  void getShopProfile() async {
    try {
      emit(ShopProfileLoading());
      var result = await sl<GetShopProfileUseCase>().call(NoParams());
      result.fold((error) {
        emit(ShopProfileFailure(message: error.message, failure: error));
      }, (data) {
        emit(ShopProfileLoaded(data));
      });
    } on ExceptionFailure catch (e) {
      emit(ShopProfileFailure(message: e.toString(), failure: e));
    }
  }
}
