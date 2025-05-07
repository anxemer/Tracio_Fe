import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/map/entities/route.dart';
import 'package:Tracio/domain/map/entities/route_blog.dart';
import 'package:Tracio/domain/map/entities/route_detail.dart';
import 'package:Tracio/domain/map/entities/route_review.dart';

abstract class RouteState {}

class GetRouteInitial extends RouteState {}

class GetRouteLoading extends RouteState {}

class GetRouteLoaded extends RouteState {
  final List<RouteEntity> routes;
  final int pageSize;
  final int pageNum;
  final String? filterValue;
  final String? filterField;
  final String? sortField;
  final bool? sortDesc;

  GetRouteLoaded({
    required this.routes,
    required this.pageSize,
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

class GetRouteDetailLoading extends RouteState {}

class GetRouteDetailLoaded extends RouteState {
  final RouteDetailEntity route;
  GetRouteDetailLoaded({required this.route});
}

class GetRouteDetailFailure extends RouteState {
  final String errorMessage;
  GetRouteDetailFailure({required this.errorMessage});
}

class GetRouteBlogLoading extends RouteState {}

class GetRouteBlogLoaded extends RouteState {
  final List<RouteBlogEntity> routeBlogs;
  final RouteReviewPaginationEntity? reviewPaginationEntity;
  final List<RouteReviewEntity> reviews;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;
  GetRouteBlogLoaded({
    required this.routeBlogs,
    required this.totalCount,
    required this.reviews,
    required this.reviewPaginationEntity,
    this.pageNumber = 1,
    this.pageSize = 5,
    this.totalPages = 1,
    this.hasPreviousPage = false,
    this.hasNextPage = false,
  });

  GetRouteBlogLoaded copyWith({
    List<RouteBlogEntity>? routeBlog,
    List<RouteReviewEntity>? reviews,
    RouteReviewPaginationEntity? reviewPaginationEntity,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    int? totalPages,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return GetRouteBlogLoaded(
      routeBlogs: routeBlogs,
      reviews: reviews ?? this.reviews,
      reviewPaginationEntity:
          reviewPaginationEntity ?? this.reviewPaginationEntity,
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}

class GetRouteBlogFailure extends RouteState {
  final String errorMessage;
  GetRouteBlogFailure({required this.errorMessage});
}
