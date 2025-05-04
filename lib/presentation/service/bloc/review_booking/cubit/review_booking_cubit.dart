import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracio_fe/domain/shop/usecase/reply_review.dart';
import 'package:tracio_fe/domain/shop/usecase/review_booking.dart';
import 'package:tracio_fe/service_locator.dart';

part 'review_booking_state.dart';

class ReviewBookingCubit extends Cubit<ReviewBookingState> {
  ReviewBookingCubit() : super(ReviewBookingInitial());

  void reviewBooking(params) async {
    try {
      emit(ReviewBookingLoading());
      var result = await sl<ReviewBookingUseCase>().call(params);
      result.fold((error) {
        emit(ReviewBookingFailure(error.message));
      }, (data) {
        emit(ReviewBookingSuccess());
      });
    } catch (e) {
      emit(ReviewBookingFailure(e.toString()));
    }
  }

   void replyReview(params) async {
    try {
      emit(ReviewBookingLoading());
      var result = await sl<ReplyReviewUseCase>().call(params);
      result.fold((error) {
        emit(ReviewBookingFailure(error.message));
      }, (data) {
        emit(ReviewBookingSuccess());
      });
    } catch (e) {
      emit(ReviewBookingFailure(e.toString()));
    }
  }
}
