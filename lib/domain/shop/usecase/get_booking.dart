import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/shop/entities/booking_entity.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class GetBookingUseCase extends Usecase<List<BookingEntity>, NoParams> {
  @override
  Future<Either<Failure, List<BookingEntity>>> call(NoParams params) async {
    return await sl<ShopServiceRepository>().getBooking();
  }
}
