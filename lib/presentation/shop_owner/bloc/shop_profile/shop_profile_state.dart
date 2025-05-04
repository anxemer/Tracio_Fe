part of 'shop_profile_cubit.dart';

sealed class ShopProfileState extends Equatable {
  const ShopProfileState();

  @override
  List<Object> get props => [];
}

final class ShopProfileInitial extends ShopProfileState {}

final class ShopProfileLoading extends ShopProfileState {}

final class ShopProfileLoaded extends ShopProfileState {
  final ShopProfileEntity shopPrifile;

  const ShopProfileLoaded(this.shopPrifile);

  @override
  List<Object> get props => [shopPrifile];
}

final class ShopProfileFailure extends ShopProfileState {
  final String message;
  final Failure failure;

  const ShopProfileFailure({required this.message, required this.failure});
  @override
  List<Object> get props => [message, failure];
}
