abstract class RouteState {}

class GetRouteInitial extends RouteState {}

class GetRouteLoading extends RouteState {}

class GetRouteLoaded extends RouteState {
  final List<dynamic> routes;

  GetRouteLoaded({required this.routes});
}

class GetRouteFailure extends RouteState {
  final String errorMessage;
  GetRouteFailure({required this.errorMessage});
}

class PostRouteLoading extends RouteState {}

class PostRouteLoaded extends RouteState {
  final bool isSucceed;
  final String successMessage;

  PostRouteLoaded({required this.isSucceed, required this.successMessage});
}

class PostRouteFailure extends RouteState {
  final String errorMessage;
  PostRouteFailure({required this.errorMessage});
}
