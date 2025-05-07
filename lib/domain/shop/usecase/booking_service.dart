import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/shop/models/booking_service_req.dart';
import 'package:Tracio/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class BookingServiceUseCase extends Usecase<bool, BookingServiceReq> {
  @override
  Future<Either<Failure, bool>> call(BookingServiceReq params) async {
    return await sl<ShopServiceRepository>().bookingService(params);
  }
}
