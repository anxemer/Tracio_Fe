import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/map/models/response/get_route_blog_rep.dart';
import 'package:tracio_fe/domain/map/repositories/route_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetRouteBlogListUsecase extends Usecase<dynamic, Map<String, String>> {
  @override
  Future<Either<Failure, GetRouteBlogRep>> call(
      Map<String, String> params) async {
    return await sl<RouteRepository>().getRouteBlogList(params);
  }
}
