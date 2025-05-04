import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/shop/models/waiting_booking.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class CompleteBookingUseCase extends Usecase<bool, int> {
  @override
  Future<Either<Failure, bool>> call(int params) async {
    return await sl<ShopServiceRepository>().completeBooking(params);
  }
}
