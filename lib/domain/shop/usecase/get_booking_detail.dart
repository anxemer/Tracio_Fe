import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/shop/entities/response/booking_detail_entity.dart';
import 'package:Tracio/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class GetBookingDetailUseCase extends Usecase<BookingDetailEntity, int> {
  @override
  Future<Either<Failure, BookingDetailEntity>> call(params) async {
    return await sl<ShopServiceRepository>().getBookingDetail(params);
  }
}
