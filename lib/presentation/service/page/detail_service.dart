import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/helper/rating_start.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/common/widget/button/text_button.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'package:Tracio/presentation/service/bloc/service_bloc/service_detail/service_detail_cubit.dart';
import 'package:Tracio/presentation/service/page/shop_service.dart';
import 'package:Tracio/presentation/service/widget/plan_service_icon.dart';
import 'package:Tracio/presentation/service/widget/review_service.dart';

import '../../../common/widget/blog/custom_bottomsheet.dart';
import '../../../common/widget/button/button.dart';
import '../../../common/widget/input_text_form_field.dart';
import '../../../common/widget/picture/circle_picture.dart';
import '../../../common/widget/picture/picture.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../core/constants/app_size.dart';
import '../bloc/cart_item_bloc/cart_item_cubit.dart';
import '../widget/add_schedule.dart';
import '../widget/all_review_service.dart';

class DetailServicePage extends StatefulWidget {
  const DetailServicePage({super.key, required this.serviceId});
  final int serviceId;

  @override
  State<DetailServicePage> createState() => _DetailServicePageState();
}

class _DetailServicePageState extends State<DetailServicePage> {
  TextEditingController noteCon = TextEditingController();
  @override
  void initState() {
    context.read<BookingServiceCubit>().clearBookingItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return BlocProvider(
      create: (context) =>
          ServiceDetailCubit()..getServiceDetail(widget.serviceId),
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            'Detail',
            style: TextStyle(
                color: Colors.grey.shade200,
                fontWeight: FontWeight.bold,
                fontSize: AppSize.textHeading.sp),
          ),
          action: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.apHorizontalPadding.w,
            ),
            child: PlanServiceIcon(
              isDetail: true,
              isActive: true,
            ),
          ),
          // height: 100.h,
        ),
        body: BlocBuilder<ServiceDetailCubit, ServiceDetailState>(
          builder: (context, state) {
            if (state is ServiceDetailLoaded) {
              return SafeArea(
                child: Column(
                  children: [
                    // buildHeader(),
                    Expanded(
                      child: Stack(
                        children: [
                          // Main scrollable content
                          ListView(
                            padding: const EdgeInsets.only(
                                bottom:
                                    70), // Add padding to prevent content from being hidden behind the button
                            children: [
                              buildImage(state.detailService.service.mediaUrl!),
                              SizedBox(
                                height: 10.h,
                              ),
                              buildTitle(
                                  state.detailService.service.serviceName!,
                                  state.detailService.service.formattedDuration,
                                  state.detailService.service.formattedPrice,
                                  state.detailService.service.formattedDistance,
                                  state.detailService.service.categoryName!),
                              SizedBox(
                                height: 10.h,
                              ),
                              Divider(
                                thickness: 4,
                                indent: 16,
                                endIndent: 16,
                                color: isDark
                                    ? Colors.black26
                                    : Colors.grey.shade300,
                                height: 1,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              shopInformation(
                                  state.detailService.service.shopName!,
                                  state.detailService.service.openTime!,
                                  state.detailService.service.closeTime!,
                                  state.detailService.service.shopId!,
                                  state.detailService.service.district!,
                                  state.detailService.service.city!,
                                  state.detailService.service.profilePicture!,
                                  state.detailService.service.address!),
                              SizedBox(
                                height: 10.h,
                              ),
                              Divider(
                                thickness: 4,
                                indent: 16,
                                endIndent: 16,
                                color: isDark
                                    ? Colors.black26
                                    : Colors.grey.shade300,
                                height: 1,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              buildDescription(
                                  state.detailService.service.description!),
                              SizedBox(
                                height: 20.h,
                              ),
                              Divider(
                                thickness: 4,
                                indent: 16,
                                endIndent: 16,
                                color: isDark
                                    ? Colors.black26
                                    : Colors.grey.shade300,
                                height: 1,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: ListTile(
                                    title: Text(
                                      'Review (${state.detailService.reviewService.length})',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: AppSize.textLarge,
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                            '${state.detailService.service.avgRating}/5'),
                                        RatingStart.ratingStart(
                                            rating: state.detailService.service
                                                .avgRating!)
                                      ],
                                    ),
                                    trailing: InkWell(
                                      onTap: () => AppNavigator.push(
                                          context,
                                          AllReviewService(
                                              serviceId: state.detailService
                                                  .service.serviceId!)),
                                      child: SizedBox(
                                        width: 100.w,
                                        child: Row(
                                          children: [
                                            Text(
                                              'View more',
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: AppSize.textMedium,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: AppSize.iconSmall,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                              state.detailService.reviewService.isEmpty
                                  ? SizedBox.shrink()
                                  : ReviewService(
                                      review: state.detailService.reviewService,
                                      avgRating: state
                                          .detailService.service.avgRating!)
                              // ListView.builder(
                              //   itemCount:
                              //       state.detailService.reviewService.length,
                              //   shrinkWrap: true,
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 16),
                              //   physics: const NeverScrollableScrollPhysics(),
                              //   itemBuilder: (context, index) {
                              //     return Container(
                              //       decoration: BoxDecoration(),
                              //       margin: EdgeInsets.only(
                              //           top: index == 0 ? 12 : 16),
                              //       // height: 120,
                              //       child: ReviewServiceCard(
                              //         review: state
                              //             .detailService.reviewService[index],
                              //       ),
                              //     );
                              //   },
                              // )
                            ],
                          ),

                          // Fixed button at bottom
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
                              child: buildButton(
                                  context,
                                  state.detailService.service.openHour!,
                                  state.detailService.service.closeHour!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state is ServiceDetailFailure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppImages.error,
                      width: AppSize.imageLarge,
                    ),
                    SizedBox(height: 16.h),
                    Text('Pull down to refresh.'),
                  ],
                ),
              );
            }
            if (state is ServiceDetailLoading) {
              Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: AppColors.secondBackground,
                  size: AppSize.iconExtraLarge,
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildHeader() {
    var isDark = context.isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                        color: context.isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                        width: 1),
                  ),
                ),
                fixedSize: WidgetStatePropertyAll(Size(40, 40)),
              ),
              icon: Icon(Icons.arrow_back_ios_new_outlined)),
          SizedBox(
            width: 20.h,
          ),
          Text(
            'Detail',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppSize.textExtraLarge,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          IconButton(
              onPressed: () {},
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Color(0xffECECEC), width: 1),
                  ),
                ),
                fixedSize: WidgetStatePropertyAll(Size(40, 40)),
              ),
              icon: Icon(Icons.playlist_add_check_outlined)),
        ],
      ),
    );
  }

  Widget buildImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 1.4,
          child: PictureCustom(
            imageUrl: imageUrl,
            width: AppSize.imageMedium,
            height: AppSize.imageMedium,
            borderRadius: AppSize.borderRadiusMedium,
          ),
        ),
      ),
    );
  }

  Padding buildTitle(String serviceName, String duration, String price,
      String distance, String category) {
    var isDark = context.isDarkMode;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: 100.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  serviceName,
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade300 : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.textHeading,
                  ),
                  maxLines: 2, // cho phép 2 dòng
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 10.h),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10.w,
                runSpacing: 4.h,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_sharp,
                        color: isDark
                            ? AppColors.secondBackground
                            : AppColors.background,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        duration,
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade300 : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: AppSize.textLarge,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.attach_money_rounded,
                        color: isDark
                            ? AppColors.secondBackground
                            : AppColors.background,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '$price VNĐ',
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade300 : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: AppSize.textLarge,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.apHorizontalPadding * .8.h,
                ),
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: AppColors.secondBackground),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.card_travel_rounded,
                      color: isDark
                          ? AppColors.secondBackground
                          : AppColors.background,
                      size: AppSize.iconSmall,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      category,
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade300 : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: AppSize.textSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Padding buildDescription(String description) {
    var isDark = context.isDarkMode;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppSize.textHeading,
                color: isDark ? Colors.grey.shade300 : Colors.black87),
          ),
          Text(
            description,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppSize.textMedium,
                color: isDark ? Colors.grey.shade300 : Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget shopInformation(
      String shopName,
      String openTime,
      String closeTime,
      int shopId,
      String district,
      String city,
      String shopImage,
      String address) {
    var isDark = context.isDarkMode;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CirclePicture(
                    imageUrl: shopImage, imageSize: AppSize.iconLarge),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopName,
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade300 : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: AppSize.textLarge,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.apHorizontalPadding * .8.h,
                        ),
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: AppColors.secondBackground),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              color: isDark
                                  ? AppColors.secondBackground
                                  : AppColors.background,
                              size: AppSize.iconSmall,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${openTime.substring(0, 5)} - ${closeTime.substring(0, 5)}',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey.shade300
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: AppSize.textSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                BasicTextButton(
                  fontSize: AppSize.textSmall,
                  onPress: () {
                    AppNavigator.push(
                      context,
                      ShopServicePage(shopId: shopId),
                    );
                  },
                  text: 'View Shop',
                  borderColor: isDark
                      ? AppColors.secondBackground
                      : AppColors.background,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5.w,
              runSpacing: 4.h,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_sharp,
                      color: isDark
                          ? AppColors.secondBackground
                          : AppColors.background,
                    ),
                  ],
                ),
                Text(
                  '$address, $district, $city',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: AppSize.textLarge,
                  ),
                ),
              ],
            ),
          ],
        ));
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
              context.read<CartItemCubit>().addCartItem(widget.serviceId);
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
                          closeTime: closeTime,
                          openTime: openTime,
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
          textColor: Colors.white,
          borderColor:
              context.isDarkMode ? Colors.grey.shade200 : Colors.black87,
          fontSize: AppSize.textMedium,
        )
      ],
    );
  }
}
