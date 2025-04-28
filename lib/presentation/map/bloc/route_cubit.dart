import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/data/map/models/request/post_route_req.dart';
import 'package:tracio_fe/domain/map/usecase/get_route_detail_usecase.dart';
import 'package:tracio_fe/domain/map/usecase/route_blog/get_route_blog_list_usecase.dart';
import 'package:tracio_fe/domain/map/usecase/route_blog/get_route_blog_reviews_usecase.dart';
import 'package:tracio_fe/domain/map/usecase/get_routes.dart';
import 'package:tracio_fe/domain/map/usecase/post_route.dart';
import 'package:tracio_fe/domain/map/usecase/route_blog/get_route_replies_usecase.dart';
import 'package:tracio_fe/presentation/map/bloc/route_state.dart';
import 'package:tracio_fe/service_locator.dart';

class RouteCubit extends Cubit<RouteState> {
  RouteCubit() : super(GetRouteInitial());

  Future<void> postRoute(PostRouteReq request) async {
    emit(PostRouteLoading());

    var data = await sl<PostRouteUseCase>().call(request);

    data.fold((error) {
      emit(PostRouteFailure(errorMessage: error.toString()));
    }, (data) async {
      emit(PostRouteLoaded(isSucceed: true, successMessage: "Create ok"));
    });
  }

  Future<void> getRoutes(GetRouteReq request) async {
    emit(GetRouteLoading());

    var data = await sl<GetRoutesUseCase>().call(request);

    data.fold((error) {
      emit(GetRouteFailure(failure: error));
    }, (data) async {
      emit(GetRouteLoaded(
          routes: data.routes,
          pageNum: data.pageNumber!,
          pageSize: data.pageSize!));
    });
  }

  Future<void> getRouteDetail(int routeId) async {
    emit(GetRouteDetailLoading());

    var data = await sl<GetRouteDetailUsecase>().call(routeId);

    data.fold((error) {
      emit(GetRouteDetailFailure(errorMessage: error.message));
    }, (data) async {
      emit(GetRouteDetailLoaded(route: data));
    });
  }

  Future<void> getRouteBlogList({int pageNumber = 1, int pageSize = 5}) async {
    emit(GetRouteBlogLoading());
    final params = {
      "pageNumber": pageNumber.toString(),
      "pageSize": pageSize.toString()
    };
    var data = await sl<GetRouteBlogListUsecase>().call(params);

    data.fold((error) {
      emit(GetRouteBlogFailure(errorMessage: error.message));
    }, (data) async {
      emit(GetRouteBlogLoaded(
        routeBlogs: data.routeBlogs,
        pageNumber: data.pageNumber,
        hasPreviousPage: data.hasPreviousPage,
        totalCount: data.totalCount,
        pageSize: data.pageSize,
        hasNextPage: data.hasNextPage,
        totalPages: data.totalPage,
        reviews: [],
        reviewPaginationEntity: null,
      ));
    });
  }

  Future<void> getRouteBlogReviews(int routeId,
      {int pageNumber = 1, int pageSize = 5}) async {
    GetRouteBlogLoaded? currentState;
    if (state is GetRouteBlogLoaded) currentState = state as GetRouteBlogLoaded;

    emit(GetRouteBlogLoading());
    final params = GetRouteBlogReviewsParams(
      routeId: routeId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    var data = await sl<GetRouteBlogReviewsUsecase>().call(params);

    data.fold((error) {
      emit(GetRouteBlogFailure(errorMessage: error.message));
    }, (reviewsData) {
      if (currentState != null) {
        emit(currentState.copyWith(
          reviews: reviewsData.reviews,
          reviewPaginationEntity: reviewsData,
        ));
        Future.wait([]);
      } else {
        emit(GetRouteBlogLoaded(
          routeBlogs: [],
          totalCount: 0,
          reviews: reviewsData.reviews,
          reviewPaginationEntity: reviewsData,
          pageNumber: 1,
          pageSize: 5,
          totalPages: 1,
          hasPreviousPage: false,
          hasNextPage: false,
        ));
      }
    });
  }

  Future<void> getRouteBlogReply(int reviewId,
      {int pageNumber = 1, int pageSize = 5}) async {
    GetRouteBlogLoaded? currentState;
    if (state is GetRouteBlogLoaded) currentState = state as GetRouteBlogLoaded;

    final params = GetRouteRepliesUsecaseParams(
      reviewId: reviewId,
      replyId: null,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    var data = await sl<GetRouteRepliesUsecase>().call(params);

    data.fold((error) {
      emit(GetRouteBlogFailure(errorMessage: error.message));
    }, (repliesData) {
      if (currentState != null) {
        final updatedReviews = currentState.reviews.map((review) {
          if (review.reviewId == reviewId) {
            return review.copyWith(
              replyPagination: repliesData,
            );
          }
          return review;
        }).toList();
        emit(currentState.copyWith(
          reviews: updatedReviews,
        ));
      } else {
        emit(GetRouteBlogLoaded(
          routeBlogs: [],
          totalCount: 0,
          reviews: [],
          reviewPaginationEntity: null,
          pageNumber: 1,
          pageSize: 5,
          totalPages: 1,
          hasPreviousPage: false,
          hasNextPage: false,
        ));
      }
    });
  }
}
