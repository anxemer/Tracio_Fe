// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/domain/map/entities/route.dart';

abstract class RouteState {}

class GetRouteInitial extends RouteState {}

class GetRouteLoading extends RouteState {}

class GetRouteLoaded extends RouteState {
  final List<RouteEntity> routes;
  final int rowsPerPage;
  final int pageNum;
  final String? filterValue;
  final String? filterField;
  final String? sortField;
  final bool? sortDesc;

  GetRouteLoaded({
    required this.routes,
    required this.rowsPerPage,
    required this.pageNum,
    this.filterValue,
    this.filterField,
    this.sortField,
    this.sortDesc,
  });
}

class GetRouteFailure extends RouteState {
  final Failure failure;
  GetRouteFailure({required this.failure});
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
