import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/shop/models/get_review_req.dart';
import 'package:Tracio/data/shop/models/reply_review_req.dart';
import 'package:Tracio/presentation/service/bloc/review_booking/cubit/review_booking_cubit.dart';
import 'package:Tracio/presentation/service/bloc/service_bloc/review_service_cubit/get_reviewcubit/get_review_cubit.dart';

import '../../../common/widget/blog/custom_bottomsheet.dart';
import '../../../common/widget/button/button.dart';
import '../../../common/widget/input_text_form_field.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/bookingservice/booking_service_cubit.dart';
import '../bloc/cart_item_bloc/cart_item_cubit.dart';
import 'add_schedule.dart';
import 'review_service_card.dart';

class AllReviewService extends StatefulWidget {
  const AllReviewService(
      {super.key,
      this.serviceId,
      this.bookingId,
      this.isShopOwner = false,
      this.isBooking = false,
      this.isReviewd = false});
  final int? serviceId;
  final int? bookingId;
  final bool isShopOwner;
  final bool isBooking;
  final bool isReviewd;
  @override
  State<AllReviewService> createState() => _AllReviewServiceState();
}

class _AllReviewServiceState extends State<AllReviewService> {
  TextEditingController noteCon = TextEditingController();
  TextEditingController replyReviewCon = TextEditingController();
  @override
  void initState() {
    if (widget.serviceId != null) {
      context.read<GetReviewCubit>().getReviewService(GetReviewReq(
          seriveId: widget.serviceId!, pageSize: 10, pageNumber: 1));
    }
    if (widget.bookingId != null) {
      context.read<GetReviewCubit>().getReviewBooking(widget.bookingId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Review',
          style: TextStyle(
              fontSize: AppSize.textHeading,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (widget.serviceId != null) {
            context.read<GetReviewCubit>().getReviewService(GetReviewReq(
                seriveId: widget.serviceId!, pageSize: 10, pageNumber: 1));
          }
          if (widget.bookingId != null) {
            context.read<GetReviewCubit>().getReviewBooking(widget.bookingId);
          }
        },
        child: BlocBuilder<GetReviewCubit, GetReviewState>(
          builder: (context, state) {
            if (state is GetReviewSuccess) {
              return Column(
                children: [
                  Expanded(
                    child: Stack(children: [
                      ListView.builder(
                        itemCount: state.review.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                              decoration: BoxDecoration(),
                              margin:
                                  EdgeInsets.only(top: index == 0 ? 12 : 16),
                              // height: 120,
                              child: ReviewServiceCard(
                                review: state.review[index],
                              ));
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: context.isDarkMode
                                ? AppColors.darkGrey
                                : Colors.grey.shade200,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black,
                            //     blurRadius: 5,
                            //     offset: const Offset(0, -3),
                            //   ),
                            // ],
                          ),
                          child: widget.isShopOwner
                              ? !widget.isReviewd
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: InputTextFormField(
                                            controller: replyReviewCon,
                                            labelText: 'Reply',
                                            hint: 'Reply This Review',
                                          ),
                                        ),

                                        // Send button
                                        IconButton(
                                          icon: Icon(
                                            Icons.send_rounded,
                                            color: context.isDarkMode
                                                ? AppColors.primary
                                                : AppColors.background,
                                            size: AppSize.iconLarge.sp,
                                          ),
                                          onPressed: () {
                                            context
                                                .read<ReviewBookingCubit>()
                                                .replyReview(ReplyReviewReq(
                                                    reviewId: state
                                                        .review.first.reviewId!,
                                                    content:
                                                        replyReviewCon.text));
                                            replyReviewCon.clear();

                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink()
                              : widget.isBooking
                                  ? buildButton(context, 7, 17)
                                  : SizedBox.shrink(),
                        ),
                      ),
                    ]),
                  ),
                ],
              );
            }
            if (state is GetReviewLoading) {
              return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                color: AppColors.secondBackground,
                size: AppSize.iconExtraLarge,
              ));
            }
            if (state is GetReviewFailure) {
              return Container();
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, int openTime, int closeTime) {
    var bookCubit = context.read<BookingServiceCubit>();
    var cartItemCubit = context.read<CartItemCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ButtonDesign(
          ontap: () async {
            bool isInCart = cartItemCubit.cartItem.any(
              (cartItem) => cartItem.serviceId == widget.serviceId,
            );

            if (isInCart) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Service is already in cart!')),
              );
            } else {
              context.read<CartItemCubit>().addCartItem(widget.serviceId!);
            }
          },
          text: 'Add To Plan',
          fillColor: Colors.transparent,
          textColor: context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
          borderColor:
              context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
          fontSize: AppSize.textMedium,
        ),
        ButtonDesign(
          ontap: () {
            CustomModalBottomSheet.show(
                initialSize: .3,
                maxSize: .4,
                minSize: .1,
                context: context,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: context.isDarkMode
                        ? AppColors.darkGrey
                        : Colors.grey.shade200,
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSize.apHorizontalPadding,
                      vertical: AppSize.apVerticalPadding),
                  // height: 100,
                  // width: double.infinity,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        AddSchedule(
                          openTime: openTime,
                          closeTime: closeTime,
                          serviceId: widget.serviceId,
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        InputTextFormField(
                            controller: noteCon,
                            labelText: 'Note',
                            hint: 'Note',
                            onFieldSubmitted: (value) {
                              bookCubit.updateNote(
                                  widget.serviceId.toString(), value);
                            }),
                      ],
                    ),
                  ),
                ));
            // AppNavigator.push(context, AddSchedule(selectCount: 1));
            // AppNavigator.push(context, MyBookingPage());
          },
          text: 'Book Now',
          // image: AppImages.share,
          fillColor: AppColors.secondBackground,
          textColor: context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
          borderColor:
              context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
          fontSize: AppSize.textMedium,
        )
      ],
    );
  }
}
