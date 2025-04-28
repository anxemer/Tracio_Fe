import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracio_fe/data/shop/models/get_review_req.dart';
import 'package:tracio_fe/domain/shop/entities/request/pagination_review_data_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/review_service_entity.dart';
import 'package:tracio_fe/domain/shop/usecase/get_review_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/get_review_service.dart';
import 'package:tracio_fe/service_locator.dart';

part 'get_review_state.dart';

class GetReviewCubit extends Cubit<GetReviewState> {
  GetReviewCubit() : super(GetReviewInitial([], null, null));

  Future<void> getReviewService(params) async {
    try {
      emit(GetReviewLoading(
          state.review, state.paginationReviewDataEntity, state.params));
      var result = await sl<GetReviewServiceUseCase>().call(params);
      result.fold((error) {
        emit(GetReviewFailure(
          state.review,
          state.paginationReviewDataEntity,
          state.params,
          error.message,
        ));
      }, (data) {
        emit(GetReviewSuccess(
            data.reviewService, data.paginationReviewDataEntity, params));
      });
    } catch (e) {
      emit(GetReviewFailure(state.review, state.paginationReviewDataEntity,
          state.params, e.toString()));
    }
  }

  Future<void> getReviewBooking(params) async {
    try {
      emit(GetReviewLoading(
          state.review, state.paginationReviewDataEntity, state.params));
      var result = await sl<GetReviewBookingUseCase>().call(params);
      result.fold((error) {
        emit(GetReviewFailure(
          state.review,
          state.paginationReviewDataEntity,
          state.params,
          error.message,
        ));
      }, (data) {
        emit(GetReviewSuccess([data], null, null));
      });
    } catch (e) {
      emit(GetReviewFailure(state.review, state.paginationReviewDataEntity,
          state.params, e.toString()));
    }
  }
}
