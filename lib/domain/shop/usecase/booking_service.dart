import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/shop/models/booking_service_req.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class BookingServiceUseCase extends Usecase<bool, BookingServiceReq> {
  @override
  Future<Either<Failure, bool>> call(BookingServiceReq params) async {
    return await sl<ShopServiceRepository>().bookingService(params);
  }
}
