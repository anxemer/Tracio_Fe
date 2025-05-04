part of 'shop_profile_manage_cubit.dart';

sealed class ShopProfileManageState extends Equatable {
  const ShopProfileManageState();

  @override
  List<Object> get props => [];
}

final class ShopProfileManageInitial extends ShopProfileManageState {}

final class ShopProfileManageLoading extends ShopProfileManageState {}

final class ShopProfileManageSuccess extends ShopProfileManageState {
  final bool success;

  const ShopProfileManageSuccess(this.success);
   @override
  List<Object> get props => [success];
}

final class ShopProfileManageFailure extends ShopProfileManageState {
  final Failure failure;
  final String message;

  const ShopProfileManageFailure(this.failure, this.message);

  @override
  List<Object> get props => [failure, message];
}
