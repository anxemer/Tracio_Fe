import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/shop/usecase/get_cart_item.dart';
import 'package:tracio_fe/presentation/service/bloc/cart_item_bloc/cart_item_state.dart';

import '../../../../service_locator.dart';

class CartItemCubit extends Cubit<CartItemState> {
  CartItemCubit() : super(GetCartItemInitial(cart: []));

  void getCartitem() async {
    emit(GetCartItemLoading(cart: []));
    var returnData = await sl<GetCartItemUseCase>().call(NoParams());

    returnData.fold((error) {
      print(state.runtimeType);
      emit(GetCartItemFailure(cart: [], failure: error));
    }, (data) {
      print(state.runtimeType);
      print(state.cart);
      emit(GetCartItemLoaded(cart: data));
    });
  }
}
