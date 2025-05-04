import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/shop/models/waiting_booking.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class ConfirmBookingUseCase extends Usecase<bool, ConfirmBookingModel> {
  @override
  Future<Either<Failure, bool>> call(ConfirmBookingModel params) async {
    return await sl<ShopServiceRepository>().confirmBooking(params);
  }
}
