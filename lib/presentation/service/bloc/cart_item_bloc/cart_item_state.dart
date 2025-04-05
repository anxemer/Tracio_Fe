// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/domain/shop/entities/response/cart_item_entity.dart';

abstract class CartItemState extends Equatable {
  final List<CartItemEntity> cart;
  const CartItemState({
    required this.cart,
  });
}

class GetCartItemInitial extends CartItemState {
  const GetCartItemInitial({required super.cart});

  @override
  List<Object?> get props => [];
}

class GetCartItemLoading extends CartItemState {
  const GetCartItemLoading({required super.cart});

  @override
  List<Object?> get props => [];
}

class GetCartItemLoaded extends CartItemState {
  const GetCartItemLoaded({required super.cart});

  @override
  List<Object?> get props => cart;
}

class GetCartItemFailure extends CartItemState {
  final Failure failure;
  const GetCartItemFailure({required super.cart, required this.failure});

  @override
  List<Object?> get props => [];
}
