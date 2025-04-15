import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/data/map/models/request/post_route_req.dart';
import 'package:tracio_fe/domain/map/usecase/get_routes.dart';
import 'package:tracio_fe/domain/map/usecase/post_route.dart';
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
          rowsPerPage: data.pageSize!));
    });
  }
}
