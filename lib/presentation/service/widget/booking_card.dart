import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/widget/list_cell_animation_view.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_card_view.dart';

import '../../../core/configs/theme/app_colors.dart';

class BookingCard<T> extends StatefulWidget {
  const BookingCard(
      {super.key,
      required this.animationController,
      required this.animation,
      this.moreWidget,
      required this.service,
      this.useAnimation = true});
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Widget? moreWidget;
  final BookingCardViewModel service;
  final bool useAnimation;

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    if (widget.useAnimation) {
      return ListCellAnimationView(
        animation: widget.animation!,
        animationController: widget.animationController!,
        child: _buildCardContent(isDark),
      );
    }
    return _buildCardContent(isDark);
  }

  Widget _buildCardContent(bool isDark) {
    return Card(
      // color: Colors.black38,
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    AppImages.picture,
                    width: AppSize.imageMedium.w,
                    height: AppSize.imageMedium.h * .8,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.service.nameService!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSize.textLarge.sp,
                              color: isDark
                                  ? Colors.grey.shade300
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money_rounded,
                            size: AppSize.iconMedium,
                            color: isDark
                                ? AppColors.secondBackground
                                : AppColors.background,
                          ),
                          Text(
                            '${widget.service.formattedPrice} \$',
                            style: TextStyle(fontSize: AppSize.textMedium),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Icon(
                            Icons.access_time_rounded,
                            size: AppSize.iconMedium,
                            color: isDark
                                ? AppColors.secondBackground
                                : AppColors.background,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            widget.service.formattedDuration,
                            style: TextStyle(fontSize: AppSize.textMedium),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.storefront_outlined,
                            size: AppSize.iconMedium,
                            color: isDark
                                ? AppColors.secondBackground
                                : AppColors.background,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            widget.service.shopName!,
                            style: TextStyle(
                                fontSize: AppSize.textMedium,
                                color: isDark
                                    ? Colors.grey.shade300
                                    : Colors.black87),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                        ],
                      ),
                      widget.service.city != null
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: AppSize.iconMedium,
                                  color: isDark
                                      ? AppColors.secondBackground
                                      : AppColors.background,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  '${widget.service.district} - ${widget.service.city}',
                                  style: TextStyle(
                                      fontSize: AppSize.textMedium,
                                      color:
                                          isDark ? Colors.white : Colors.black),
                                ),
                              ],
                            )
                          : Container()
                      // Text(
                      //   'Labuan Bajo is a fishing town located at the western end of the large island of Flores in the East Nusa Tenggara province of Indonesia. It is in Komodo district.',
                      //   maxLines: 2,
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w400,
                      //     fontSize: 14,
                      //     color: Colors.grey.shade600,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            widget.moreWidget ?? Container()
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade600,
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(
            //       color: Colors.yellow.shade200,
            //     ),
            //   ),
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     'Choose',
            //     style: TextStyle(
            //       fontWeight: FontWeight.w600,
            //       fontSize: 14,
            //       color: Colors.yellow.shade200,
            //     ),
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     ButtonDesign(
            //       ontap: () {},
            //       text: 'Edit',
            //       fillColor: Colors.transparent,
            //       textColor: context.isDarkMode
            //           ? Colors.grey.shade200
            //           : Colors.black87,
            //       borderColor: context.isDarkMode
            //           ? Colors.grey.shade200
            //           : Colors.black87,
            //       fontSize: AppSize.textMedium,
            //     ),
            //     SizedBox(
            //       width: 20.w,
            //     ),
            //     ButtonDesign(
            //       ontap: () async {
            //         // var time = showTimePicker(
            //         //   context: context,
            //         //   initialTime: TimeOfDay.now(),

            //         // );
            //       },
            //       text: 'Cancel',
            //       fillColor: AppColors.secondBackground,
            //       textColor: context.isDarkMode
            //           ? Colors.grey.shade200
            //           : Colors.black87,
            //       borderColor: context.isDarkMode
            //           ? Colors.grey.shade200
            //           : Colors.black87,
            //       fontSize: AppSize.textMedium,
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
