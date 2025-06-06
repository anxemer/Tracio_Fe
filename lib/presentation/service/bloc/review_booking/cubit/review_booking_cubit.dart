import 'package:Tracio/core/erorr/failure.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:Tracio/domain/shop/usecase/reply_review.dart';
import 'package:Tracio/domain/shop/usecase/review_booking.dart';
import 'package:Tracio/service_locator.dart';

part 'review_booking_state.dart';

class ReviewBookingCubit extends Cubit<ReviewBookingState> {
  ReviewBookingCubit() : super(ReviewBookingInitial());

  void reviewBooking(params) async {
    try {
      emit(ReviewBookingLoading());
      var result = await sl<ReviewBookingUseCase>().call(params);
      result.fold((error) {
        emit(ReviewBookingFailure(error.message,error));
      }, (data) {
        emit(ReviewBookingSuccess());
      });
    }on Failure catch (e) {
      emit(ReviewBookingFailure(e.toString(),e));
    }
  }

  void replyReview(params) async {
    try {
      emit(ReviewBookingLoading());
      var result = await sl<ReplyReviewUseCase>().call(params);
      result.fold((error) {
        emit(ReviewBookingFailure(error.message,error));
      }, (data) {
        emit(ReviewBookingSuccess());
      });
    }on Failure catch (e) {
      emit(ReviewBookingFailure(e.toString(),e));
    }
  }
}
