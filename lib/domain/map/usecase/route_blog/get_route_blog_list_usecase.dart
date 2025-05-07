import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/map/models/response/get_route_blog_rep.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetRouteBlogListUsecase extends Usecase<dynamic, Map<String, String>> {
  @override
  Future<Either<Failure, GetRouteBlogRep>> call(
      Map<String, String> params) async {
    return await sl<RouteRepository>().getRouteBlogList(params);
  }
}
