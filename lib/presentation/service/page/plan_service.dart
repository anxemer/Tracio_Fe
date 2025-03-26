import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/shop/entities/booking_card_view.dart';
import 'package:tracio_fe/domain/shop/entities/cart_item_entity.dart';
import 'package:tracio_fe/presentation/service/bloc/cart_item_bloc/cart_item_cubit.dart';
import 'package:tracio_fe/presentation/service/widget/add_schedule.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../bloc/cart_item_bloc/cart_item_state.dart';
import '../widget/booking_card.dart';

class PlanServicePage extends StatefulWidget {
  const PlanServicePage({super.key});

  @override
  State<PlanServicePage> createState() => _PlanServicePageState();
}

class _PlanServicePageState extends State<PlanServicePage>
    with TickerProviderStateMixin {
  List<CartItemEntity> cartItem = [];

  List<CartItemEntity> selectedService = [];

  late AnimationController screenAnimationController;
  final TextEditingController timeFromCon = TextEditingController();
  TextEditingController timeToCon = TextEditingController();
  final dateTimeController = TextEditingController();
  @override
  void initState() {
    screenAnimationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    screenAnimationController.forward();
    // widget.animationController.forward();
    context.read<CartItemCubit>().getCartitem();
    super.initState();
  }

  @override
  void dispose() {
    screenAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = -1;
    var isDark = context.isDarkMode;
    return Scaffold(
      appBar: BasicAppbar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Plan',
          style: TextStyle(
              fontSize: AppSize.textHeading.sp,
              color: isDark ? Colors.grey.shade200 : Colors.black87,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<CartItemCubit, CartItemState>(
        builder: (context, state) {
          if (state is GetCartItemLoaded) {
            return Column(
              children: [
                Expanded(
                  child: Stack(children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 60.h),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: state.cart.length,
                        itemBuilder: (context, index) {
                          var animation = Tween(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: screenAnimationController,
                                  curve: Interval(0.0, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                          screenAnimationController.forward();
                          bool isSelected =
                              selectedService.contains(state.cart[index]);
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: BookingCard(
                              service: BookingCardViewModel(
                                  nameService: state.cart[index].serviceName!,
                                  price: state.cart[index].price.toString(),
                                  shopName: state.cart[index].shopName!),
                              animationController: screenAnimationController,
                              animation: animation,
                              moreWidget: InkWell(
                                onTap: () {
                                  if (!isSelected) {
                                    setState(() {
                                      selectedService.add(state.cart[index]);
                                    });
                                  } else {
                                    setState(() {
                                      selectedService.remove(state.cart[index]);
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: !isSelected
                                        ? Colors.blue.shade50
                                        : Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(
                                        AppSize.borderRadiusSmall),
                                    border: Border.all(
                                      color: selectedIndex != index
                                          ? Colors.blue.shade100
                                          : Colors.green.shade100,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      !isSelected
                                          ? Text(
                                              'Select this service',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: AppSize.textMedium,
                                                color: Colors.blue.shade500,
                                              ),
                                            )
                                          : Text(
                                              'remove this service',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: AppSize.textMedium,
                                                color: Colors.green.shade500,
                                              ),
                                            ),
                                      isSelected
                                          ? Icon(
                                              Icons.playlist_add_check_sharp,
                                              size: AppSize.iconSmall,
                                              color: Colors.black,
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? AppColors.darkGrey
                              : Colors.grey.shade200,
                      
                        ),
                        child: AddSchedule(cartItem: selectedService,),
                      ),
                    ),
                  ]),
                ),
              ],
            );
          } else if (state is GetCartItemLoading) {
            Center(child: CircularProgressIndicator());
          }
          return Container();
        },
      ),
    );
  }
}
