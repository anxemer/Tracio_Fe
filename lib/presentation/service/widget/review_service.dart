import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/domain/shop/entities/response/review_service_entity.dart';
import 'package:Tracio/presentation/service/widget/review_service_card.dart';
import '../../../core/constants/app_size.dart';
import '../../../data/shop/models/get_review_req.dart';
import '../bloc/service_bloc/review_service_cubit/get_reviewcubit/get_review_cubit.dart';

class ReviewService extends StatefulWidget {
  const ReviewService({
    super.key,
    this.review,
    this.avgRating,
    this.bookingDetailId,
  });
  final int? bookingDetailId;
  final List<ReviewServiceEntity>? review;
  final double? avgRating;

  @override
  State<ReviewService> createState() => _ReviewServiceState();
}

class _ReviewServiceState extends State<ReviewService> {
  late final List<ReviewServiceEntity>? passedReview;

  @override
  void initState() {
    super.initState();

    passedReview = widget.review;

    if (passedReview == null || passedReview!.isEmpty) {
      context.read<GetReviewCubit>().getReviewBooking(
            widget.bookingDetailId!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (passedReview != null && passedReview!.isNotEmpty) {
      return _buildReviewList(passedReview!);
    }

    return BlocBuilder<GetReviewCubit, GetReviewState>(
      builder: (context, state) {
        if (state is GetReviewLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetReviewSuccess) {
          final reviews = state.review;

          if (reviews.isEmpty) {
            return const Center(
              child: Text(
                'No reviews yet',
                style: TextStyle(
                    fontSize: AppSize.textLarge, fontWeight: FontWeight.bold),
              ),
            );
          }

          return _buildReviewList(reviews);
        } else if (state is GetReviewFailure) {
          return Center(child: Text("Error loading reviews: ${state.message}"));
        }

        return const Center(
          child: Text(
            'No reviews yet',
            style: TextStyle(
                fontSize: AppSize.textLarge, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Widget _buildReviewList(List<ReviewServiceEntity> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          itemCount: reviews.length,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: index == 0 ? 12 : 16),
              child: ReviewServiceCard(
                review: reviews[index],
              ),
            );
          },
        ),
      ],
    );
  }
}
