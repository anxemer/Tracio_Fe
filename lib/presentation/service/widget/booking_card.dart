import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/widget/list_cell_animation_view.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_card_view.dart';

import '../../../core/configs/theme/app_colors.dart';

class BookingCard<T> extends StatefulWidget {
  const BookingCard(
      {super.key,
      this.animationController,
      this.animation,
      this.moreWidget,
      required this.service,
      this.useAnimation = true,
      this.imageSize,
      this.backgroundColor,
      this.ontap});
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Widget? moreWidget;
  final BookingCardViewModel service;
  final bool useAnimation;
  final double? imageSize;
  final Color? backgroundColor;
  final VoidCallback? ontap;
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
      color: widget.backgroundColor,
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            InkWell(
              onTap: widget.ontap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      AppImages.picture,
                      width: widget.imageSize ?? AppSize.imageMedium.w,
                      height: widget.imageSize ?? AppSize.imageMedium.h * .8,
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
                        Text(
                          widget.service.nameService!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppSize.textMedium.sp,
                            color:
                                isDark ? Colors.grey.shade300 : Colors.black87,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            widget.service.price != null
                                ? Row(
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
                                        style: TextStyle(
                                            fontSize: AppSize.textMedium),
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              width: 20.w,
                            ),
                            widget.service.duration != null
                                ? Row(
                                    children: [
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
                                        style: TextStyle(
                                            fontSize: AppSize.textMedium),
                                      ),
                                    ],
                                  )
                                : Container(),
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
                                    size: AppSize.iconSmall,
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
                                        fontSize: AppSize.textSmall,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              )
                            : Container(),
                        // Text(
                        //   'Labuan Bajo is a fishing town located at the western end of the large island of Flores in the East Nusa Tenggara province of Indonesia. It is in Komodo district.',
                        //   maxLines: 2,
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w400,
                        //     fontSize: 14,
                        //     color: Colors.grey.shade600,
                        //   ),
                        // ),
                        widget.service.bookedDate != null
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.schedule_outlined,
                                    size: AppSize.iconMedium,
                                    color: isDark
                                        ? AppColors.secondBackground
                                        : AppColors.background,
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy HH:mm')
                                        .format(widget.service.bookedDate!),
                                    style: TextStyle(
                                        fontSize: AppSize.textMedium,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            widget.moreWidget ?? Container()
          ],
        ),
      ),
    );
  }
}
