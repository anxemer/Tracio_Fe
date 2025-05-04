part of 'get_review_cubit.dart';

sealed class GetReviewState extends Equatable {
  const GetReviewState(
      this.review, this.paginationReviewDataEntity, this.params);
  final List<ReviewServiceEntity> review;
  final PaginationReviewDataEntity? paginationReviewDataEntity;
  final GetReviewReq? params;

  @override
  List<Object> get props => [];
}

final class GetReviewInitial extends GetReviewState {
  const GetReviewInitial(
      super.review, super.paginationReviewDataEntity, super.params);
}

final class GetReviewLoading extends GetReviewState {
  const GetReviewLoading(
      super.review, super.paginationReviewDataEntity, super.params);
}

final class GetReviewSuccess extends GetReviewState {
  const GetReviewSuccess(
      super.review, super.paginationReviewDataEntity, super.params);
  @override
  List<Object> get props => [review];
}

final class GetReviewFailure extends GetReviewState {
  final String message;

  const GetReviewFailure(super.review, super.paginationReviewDataEntity,
      super.params, this.message);

  @override
  List<Object> get props => [review, message];
}
