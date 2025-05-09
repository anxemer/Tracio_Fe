import 'package:Tracio/data/shop/models/get_detail_service_req.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/shop/entities/response/detail_service_response_entity.dart';
import 'package:Tracio/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class GetServiceDetailUseCase
    extends Usecase<DetailServiceResponseEntity, GetDetailServiceReq> {
  @override
  Future<Either<Failure, DetailServiceResponseEntity>> call(params) async {
    return await sl<ShopServiceRepository>().getServiceDetail(params);
  }
}
