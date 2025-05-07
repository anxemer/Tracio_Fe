import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/shop/entities/response/booking_detail_entity.dart';
import 'package:Tracio/domain/shop/usecase/get_booking_detail.dart';
import 'package:Tracio/service_locator.dart';

part 'get_booking_detail_state.dart';

class GetBookingDetailCubit extends Cubit<GetBookingDetailState> {
  GetBookingDetailCubit() : super(GetBookingDetailInitial());
  BookingDetailEntity bookingdetail = BookingDetailEntity();
  void getBookingDetail(params) async {
    emit(GetBookingDetailLoading());
    var result = await sl<GetBookingDetailUseCase>().call(params);
    result.fold((error) {
      emit(GetBookingDetailFailure(error.message, error));
    }, (data) {
      bookingdetail = data;
      emit(GetBookingDetailLoaded(data));
    });
  }
}
