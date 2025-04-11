import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_detail_entity.dart';
import 'package:tracio_fe/domain/shop/usecase/get_booking_detail.dart';
import 'package:tracio_fe/service_locator.dart';

part 'get_booking_detail_state.dart';

class GetBookingDetailCubit extends Cubit<GetBookingDetailState> {
  GetBookingDetailCubit() : super(GetBookingDetailInitial());
  BookingDetailEntity bookingdetail = BookingDetailEntity();
  void getBookingDetail(params) async {
    emit(GetBookingDetailLoading());
    var result = await sl<GetBookingDetailUseCase>().call(params);
    result.fold((error) {
      emit(GetBookingDetailFailure(error.message));
    }, (data) {
      bookingdetail = data;
      emit(GetBookingDetailLoaded(data));
    });
  }
}
