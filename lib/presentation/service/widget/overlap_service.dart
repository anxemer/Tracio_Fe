import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_entity.dart';
import 'package:tracio_fe/presentation/service/widget/booking_card.dart';

import '../../../common/widget/button/button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../domain/shop/entities/response/booking_card_view.dart';

class OverlapService extends StatefulWidget {
  const OverlapService(
      {super.key,
      required this.overlapList,
      required this.animationController});
  final List<BookingEntity> overlapList;
  final AnimationController animationController;
  @override
  State<OverlapService> createState() => _OverlapServiceState();
}

class _OverlapServiceState extends State<OverlapService> {
  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSize.borderRadiusMedium),
              topRight: Radius.circular(AppSize.borderRadiusMedium))),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.green,
              ),
            ),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Change a few things up and try submitting again!',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.overlapList.length,
              itemBuilder: (context, index) {
                var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve:
                            Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));
                widget.animationController.forward();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BookingCard(
                    service: BookingCardViewModel(
                        shopName: widget.overlapList[index].shopName,
                        duration: widget.overlapList[index].duration,
                        nameService: widget.overlapList[index].serviceName,
                        price: widget.overlapList[index].price),
                    animation: animation,
                    animationController: widget.animationController,
                    moreWidget: Column(
                      children: [
                        // Container(
                        //   padding:
                        //       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        //   decoration: BoxDecoration(
                        //     color: Colors.green.shade50,
                        //     borderRadius:
                        //         BorderRadius.circular(AppSize.borderRadiusSmall),
                        //     border: Border.all(
                        //       color: Colors.green.shade100,
                        //     ),
                        //   ),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         'Pending',
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: AppSize.textMedium,
                        //           color: Colors.black87,
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonDesign(
                              width: 160,
                              height: 40,
                              ontap: () {},
                              text: 'Reschedule',
                              fillColor: Colors.transparent,
                              textColor: isDark
                                  ? Colors.grey.shade200
                                  : Colors.black87,
                              borderColor: isDark
                                  ? Colors.grey.shade200
                                  : Colors.black87,
                              fontSize: AppSize.textMedium,
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            ButtonDesign(
                              width: 160,
                              height: 40,
                              ontap: () async {
                                // var time = showTimePicker(
                                //   context: context,
                                //   initialTime: TimeOfDay.now(),

                                // );
                              },
                              text: 'Confirm',
                              fillColor: AppColors.secondBackground,
                              textColor:
                                  isDark ? Colors.grey.shade200 : Colors.white,
                              borderColor: context.isDarkMode
                                  ? Colors.grey.shade200
                                  : Colors.black87,
                              fontSize: AppSize.textMedium,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
