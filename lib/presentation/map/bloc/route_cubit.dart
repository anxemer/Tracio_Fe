import 'package:Tracio/data/map/models/request/post_route_media_req.dart';
import 'package:Tracio/data/map/models/request/update_route_req.dart';
import 'package:Tracio/domain/map/entities/route_media.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/domain/map/usecase/edit_route_tracking_usecase.dart';
import 'package:Tracio/domain/map/usecase/post_route_media_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/map/models/request/get_route_req.dart';
import 'package:Tracio/data/map/models/request/post_route_req.dart';
import 'package:Tracio/domain/map/usecase/get_route_detail_usecase.dart';
import 'package:Tracio/domain/map/usecase/route_blog/get_route_blog_list_usecase.dart';
import 'package:Tracio/domain/map/usecase/route_blog/get_route_blog_reviews_usecase.dart';
import 'package:Tracio/domain/map/usecase/get_routes.dart';
import 'package:Tracio/domain/map/usecase/post_route.dart';
import 'package:Tracio/domain/map/usecase/route_blog/get_route_replies_usecase.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:Tracio/service_locator.dart';

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

  Future<void> getRides(GetRouteLoaded? loadedState,
      {int pageSize = 10,
      int pageNumber = 1,
      Map<String, String>? filterParams}) async {
    if (pageNumber == 1) {
      emit(GetRouteLoading());
    }
    final currentRides = loadedState?.rides ?? [];
    final addedFilter = {
      ...?filterParams,
      "isPlanned": "false",
    };
    GetRouteReq request = GetRouteReq(
        pageNumber: pageNumber, pageSize: pageSize, params: addedFilter);
    var data = await sl<GetRoutesUseCase>().call(request);
    data.fold((error) {
      emit(GetRouteFailure(failure: ExceptionFailure(error.message)));
    }, (data) async {
      final newRides =
          pageNumber == 1 ? data.routes : [...currentRides, ...data.routes];
      emit(GetRouteLoaded(
        rides: newRides,
        plans: loadedState?.plans ?? [],
        ridePagination: data,
        plansPagination: loadedState?.plansPagination,
      ));
    });
  }

  Future<void> getPlans(
    GetRouteLoaded? loadedState, {
    int pageSize = 10,
    int pageNumber = 1,
    Map<String, String>? filterParams,
  }) async {
    if (pageNumber == 1) {
      emit(GetRouteLoading());
    }

    final currentPlans = loadedState?.plans ?? [];

    final addedFilter = {
      ...?filterParams,
      "isPlanned": "true",
    };

    final request = GetRouteReq(
      pageNumber: pageNumber,
      pageSize: pageSize,
      params: addedFilter,
    );

    final result = await sl<GetRoutesUseCase>().call(request);

    result.fold(
      (error) {
        emit(GetRouteFailure(failure: ExceptionFailure(error.message)));
      },
      (pagination) async {
        final newPlans = pageNumber == 1
            ? pagination.routes
            : [...currentPlans, ...pagination.routes];

        emit(GetRouteLoaded(
          rides: loadedState?.rides ?? [],
          plans: newPlans,
          ridePagination: loadedState?.ridePagination,
          plansPagination: pagination,
        ));
      },
    );
  }

  Future<void> getRouteDetail(int routeId) async {
    emit(GetRouteDetailLoading());

    var data = await sl<GetRouteDetailUsecase>().call(routeId);

    data.fold((error) {
      emit(GetRouteDetailFailure(errorMessage: error.message));
    }, (data) async {
      List<RouteMediaEntity> routeMediaFiles = [
        RouteMediaEntity(
            mediaId: -1,
            mediaUrl: data.routeThumbnail,
            capturedAt: data.createdAt,
            uploadedAt: data.updatedAt)
      ];
      emit(GetRouteDetailLoaded(route: data, routeMediaFiles: routeMediaFiles));

      if (data.mediaFileCounts > 0) {
        var response =
            await sl<RouteRepository>().getRouteMediaFiles(data.routeId);
        response.fold((error) {}, (imageData) {
          routeMediaFiles.addAll(imageData);
          emit(GetRouteDetailLoaded(
              route: data, routeMediaFiles: routeMediaFiles));
        });
      }
    });
  }

  Future<void> getRouteBlogList({int pageNumber = 1, int pageSize = 5}) async {
    // If we're loading the first page, show loading indicator
    if (pageNumber == 1) {
      emit(GetRouteBlogLoading());
    }

    final params = {
      "pageNumber": pageNumber.toString(),
      "pageSize": pageSize.toString(),
    };

    final result = await sl<GetRouteBlogListUsecase>().call(params);

    result.fold(
      (error) => emit(GetRouteBlogFailure(errorMessage: error.message)),
      (data) {
        final previousState = state;

        // Append to existing list if already loaded and pageNumber > 1
        final updatedBlogs =
            (previousState is GetRouteBlogLoaded && pageNumber > 1)
                ? [...previousState.routeBlogs, ...data.routeBlogs]
                : data.routeBlogs;

        emit(GetRouteBlogLoaded(
          routeBlogs: updatedBlogs,
          pageNumber: data.pageNumber,
          hasPreviousPage: data.hasPreviousPage,
          totalCount: data.totalCount,
          pageSize: data.pageSize,
          hasNextPage: data.hasNextPage,
          totalPages: data.totalPage,
          reviews:
              previousState is GetRouteBlogLoaded ? previousState.reviews : [],
          reviewPaginationEntity: previousState is GetRouteBlogLoaded
              ? previousState.reviewPaginationEntity
              : null,
        ));
      },
    );
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

  Future<void> updateRouteWithMedia(
    UpdateRouteReq updateReq,
    List<PostRouteMediaReq> mediaFiles,
  ) async {
    emit(UpdateRouteLoading());

    final editResult = await sl<EditRouteTrackingUsecase>().call(updateReq);

    // If route update fails, exit early
    if (editResult.isLeft()) {
      final error = (editResult as Left).value as Failure;
      emit(UpdateRouteFailure(errorMessage: error.message));
      return;
    }

    // Upload media files sequentially
    final total = mediaFiles.length;
    for (int i = 0; i < total; i++) {
      final file = mediaFiles[i];

      emit(UpdateRouteLoadingProgress(
        currentIndex: i + 1,
        totalCount: total,
        statusMessage: 'Uploading file ${i + 1} of $total...',
      ));
      final uploadResult = await sl<PostRouteMediaUsecase>().call(file);
      if (uploadResult.isLeft()) {
        final error = (uploadResult as Left).value as Failure;
        emit(UpdateRouteFailure(errorMessage: error.message));
        return;
      }
    }

    emit(UpdateRouteLoaded(
      isSucceed: true,
      successMessage: 'Route updated and media files uploaded successfully.',
    ));
  }

  Future<void> uploadMediaWithLocation(PostRouteMediaReq mediaFile) async {
    emit(UpdateRouteLoading());
    emit(UpdateRouteLoadingProgress(
      currentIndex: 1,
      totalCount: 1,
      statusMessage: 'Uploading file...',
    ));
    final uploadResult = await sl<PostRouteMediaUsecase>().call(mediaFile);
    if (uploadResult.isLeft()) {
      final error = (uploadResult as Left).value as Failure;
      emit(UpdateRouteFailure(errorMessage: error.message));
      return;
    }

    emit(UpdateRouteLoaded(
      isSucceed: true,
      successMessage: 'Route updated and media files uploaded successfully.',
    ));
  }
}
