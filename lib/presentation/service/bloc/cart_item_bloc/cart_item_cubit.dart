import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/shop/entities/response/cart_item_entity.dart';
import 'package:tracio_fe/domain/shop/usecase/add_to_cart.dart';
import 'package:tracio_fe/domain/shop/usecase/delete_cart_item.dart';
import 'package:tracio_fe/domain/shop/usecase/get_cart_item.dart';
import 'package:tracio_fe/presentation/service/bloc/cart_item_bloc/cart_item_state.dart';

import '../../../../service_locator.dart';

class CartItemCubit extends Cubit<CartItemState> {
  CartItemCubit() : super(GetCartItemInitial(cart: []));
  List<CartItemEntity> cartItem = [];
  void getCartitem() async {
    emit(GetCartItemLoading(cart: []));
    var returnData = await sl<GetCartItemUseCase>().call(NoParams());

    returnData.fold((error) {
      emit(GetCartItemFailure(cart: [], failure: error));
    }, (data) {
      cartItem = data;
      emit(GetCartItemLoaded(cart: data));
    });
  }

  void deleteCartItem(int params) async {
    final updatedCart = List<CartItemEntity>.from(state.cart)
      ..removeWhere((item) => item.itemId == params);
    emit(GetCartItemLoaded(cart: updatedCart));
    var returnData = await sl<DeleteCartItemUseCase>().call(params);
    returnData.fold((error) {
      emit(GetCartItemFailure(cart: state.cart, failure: error));
    }, (data) {
      cartItem.removeWhere((item) => item.itemId == params);
      emit(GetCartItemLoaded(cart: cartItem));
    });
  }

  void resetState() {
    emit(GetCartItemInitial(cart: cartItem));
  }

  void addCartItem(int itemId) async {
    var returnData = await sl<AddToCartUseCase>().call(itemId);
    returnData.fold(
      (error) {
        emit(GetCartItemFailure(cart: state.cart, failure: error));
      },
      (data) {
        print(state.runtimeType);

        getCartitem();
        emit(GetCartItemLoaded(cart: cartItem));
      },
    );
  }
}
