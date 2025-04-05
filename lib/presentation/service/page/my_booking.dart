import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:tracio_fe/presentation/service/widget/plan_service_icon.dart';
import 'package:tracio_fe/presentation/service/widget/waitting_service.dart';

import '../../../common/widget/bottom_top_move_animation.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../widget/pending_service.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});
  // final List<ShopServiceEntity> serviceBooking;

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage>
    with TickerProviderStateMixin {
  late AnimationController tabAnimationController;
  late AnimationController screenAnimationController;

  TopBarType topBarType = TopBarType.Pending;

  @override
  void initState() {
    screenAnimationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    tabAnimationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    indexView = PendingService(
      // servicePending: widget.serviceBooking,
      animationController: screenAnimationController,
    );
    tabAnimationController.forward();
    screenAnimationController.forward();
    // widget.animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    screenAnimationController.dispose();

    tabAnimationController.dispose();
    super.dispose();
  }

  Widget indexView = Container();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetBookingCubit(),
      child: Scaffold(
        appBar: BasicAppbar(
            backgroundColor: Colors.transparent,
            title: Text('My Booking'),
            action: PlanServiceIcon()
            //  Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: AppSize.apHorizontalPadding.w,
            //   ),
            //   child:
            //    Container(
            //       height: 40.h,
            //       width: 40.w,
            //       decoration:
            //        BoxDecoration(
            //           boxShadow: [
            //             BoxShadow(
            //                 blurRadius: 5,
            //                 color: context.isDarkMode
            //                     ? Colors.transparent
            //                     : Colors.grey.shade400,
            //                 offset: Offset(0, 2))
            //           ],
            //           color: context.isDarkMode
            //               ? AppColors.darkGrey
            //               : Colors.grey.shade200,
            //           borderRadius:
            //               BorderRadius.circular(AppSize.borderRadiusLarge),
            //           border: Border.all(color: Colors.grey.shade200)),
            //       child: Icon(
            //         Icons.edit_calendar_rounded,
            //         color: Colors.black87,
            //         size: AppSize.iconMedium,
            //       )),
            // ),
            ),
        body: BottomTopMoveAnimationView(
          animationController: screenAnimationController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //upcoming finished favorites selected
              _topViewUI(topBarType),
              //hotel list view
              Expanded(
                child: indexView,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topViewUI(TopBarType tabtype) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: context.isDarkMode ? Colors.black38 : Colors.grey.shade200),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                _getTopBarUi(() {
                  tabClick(TopBarType.Pending);
                },
                    topBarType == TopBarType.Pending
                        ? context.isDarkMode
                            ? AppColors.secondBackground
                            : AppColors.background
                        : context.isDarkMode
                            ? Colors.grey.shade300
                            : AppColors.darkGrey,
                    "Pending"),
                _getTopBarUi(() {
                  tabClick(TopBarType.Waitting);
                },
                    topBarType == TopBarType.Waitting
                        ? context.isDarkMode
                            ? AppColors.secondBackground
                            : AppColors.background
                        : context.isDarkMode
                            ? Colors.grey.shade300
                            : AppColors.darkGrey,
                    "Waitting"),
                _getTopBarUi(() {
                  tabClick(TopBarType.Processing);
                },
                    topBarType == TopBarType.Processing
                        ? context.isDarkMode
                            ? AppColors.secondBackground
                            : AppColors.background
                        : context.isDarkMode
                            ? Colors.grey.shade300
                            : AppColors.darkGrey,
                    "Processing"),
                _getTopBarUi(() {
                  tabClick(TopBarType.Completed);
                },
                    topBarType == TopBarType.Completed
                        ? context.isDarkMode
                            ? AppColors.secondBackground
                            : AppColors.background
                        : context.isDarkMode
                            ? Colors.grey.shade300
                            : AppColors.darkGrey,
                    "Completed"),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget _getTopBarUi(VoidCallback onTap, Color color, String text) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          highlightColor: color,
          splashColor: Theme.of(context).primaryColor.withValues(alpha: .2),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 16),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    color: color,
                    fontSize: AppSize.textMedium,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void tabClick(TopBarType tabType) {
    if (tabType != topBarType) {
      topBarType = tabType;
      tabAnimationController.reverse().then((f) {
        if (tabType == TopBarType.Pending) {
          setState(() {
            indexView = PendingService(
              // servicePending: widget.serviceBooking,
              animationController: tabAnimationController,
            );
          });
        } else if (tabType == TopBarType.Waitting) {
          setState(() {
            indexView = WaittingService(
              animationController: tabAnimationController,
            );
          });
        } else if (tabType == TopBarType.Completed) {
          // setState(() {
          //   indexView = PendingListView();
          // });
          // setState(() {
          //   indexView = FavoritesListView(
          //     animationController: tabAnimationController,
          //   );
          // });
        }
        tabAnimationController.forward();
      });
    }
  }
}

enum TopBarType { Pending, Waitting, Processing, Completed }
