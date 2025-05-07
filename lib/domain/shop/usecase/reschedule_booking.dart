import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/shop/models/reschedule_booking_model.dart';
import 'package:Tracio/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class RescheduleBookingUseCase extends Usecase<bool, RescheduleBookingModel> {
  @override
  Future<Either<Failure, bool>> call(RescheduleBookingModel params) async {
    return await sl<ShopServiceRepository>().rescheduleBooking(params);
  }
}
