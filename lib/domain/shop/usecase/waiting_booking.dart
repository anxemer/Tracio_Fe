import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/shop/models/reschedule_booking_model.dart';
import 'package:tracio_fe/data/shop/models/waiting_booking.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class WaitingBookingUseCase extends Usecase<bool, WaitingModel> {
  @override
  Future<Either<Failure, bool>> call(WaitingModel params) async {
    return await sl<ShopServiceRepository>().waitingBooking(params);
  }
}
