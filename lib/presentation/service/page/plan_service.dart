import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/domain/shop/entities/response/cart_item_entity.dart';
import 'package:Tracio/presentation/service/page/detail_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/common/widget/input_text_form_field.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/shop/entities/response/booking_card_view.dart';
import 'package:Tracio/presentation/service/bloc/cart_item_bloc/cart_item_cubit.dart';
import 'package:Tracio/presentation/service/widget/add_schedule.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../bloc/bookingservice/booking_service_cubit.dart';
import '../bloc/cart_item_bloc/cart_item_state.dart';
import '../widget/booking_card.dart';

class PlanServicePage extends StatefulWidget {
  const PlanServicePage({super.key});

  @override
  State<PlanServicePage> createState() => _PlanServicePageState();
}

class _PlanServicePageState extends State<PlanServicePage>
    with TickerProviderStateMixin {
  // List<CartItemEntity> cartItem = [];

  // List<CartItemEntity> selectedService = [];

  late AnimationController screenAnimationController;
  final TextEditingController timeFromCon = TextEditingController();
  TextEditingController timeToCon = TextEditingController();
  final dateTimeController = TextEditingController();
  List<BookingCardViewModel> bookingModel = [];
  final Map<String, String> _serviceNotes = {};
  final Map<String, TextEditingController> _controllers = {};
  @override
  void initState() {
    screenAnimationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    screenAnimationController.forward();
    // widget.animationController.forward();
    context.read<CartItemCubit>().getCartitem();
    context.read<BookingServiceCubit>().clearBookingItem();

    // context.read<CartItemCubit>().resetState();
    // bookingModel = selectedService.map((item) {
    //   return BookingCardViewModel(
    //       nameService: item.serviceName,
    //       price: item.price.toString(),
    //       shopName: item.shopName);
    // }).toList();

    super.initState();
  }

  @override
  void dispose() {
    screenAnimationController.dispose();
    _controllers.forEach((_, controller) => controller.dispose());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingCubit = context.read<BookingServiceCubit>();
    Map<String, int?> calculateOperatingHours(List<CartItemEntity> cartItem) {
      if (cartItem.isEmpty) {
        return {"minOpenHour": null, "maxCloseHour": null};
      }

      // Tìm giờ mở cửa nhỏ nhất
      int? minOpenHour = cartItem
          .map((booking) => booking.openHour)
          .where((hour) => hour != null)
          .reduce((a, b) => a! < b! ? a : b);

      // Tìm giờ đóng cửa lớn nhất
      int? maxCloseHour = cartItem
          .map((booking) => booking.closeHour)
          .where((hour) => hour != null)
          .reduce((a, b) => a! > b! ? a : b);

      // Trả về kết quả dưới dạng một Map
      return {"minOpenHour": minOpenHour, "maxCloseHour": maxCloseHour};
    }

    // int selectedIndex = -1;
    var isDark = context.isDarkMode;
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Plan',
          style: TextStyle(
              fontSize: AppSize.textHeading.sp,
              color: Colors.grey.shade200,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<CartItemCubit, CartItemState>(
        builder: (context, state) {
          if (state is GetCartItemLoaded) {
            var operatingHours = calculateOperatingHours(state.cart);
            int? minOpenHour = operatingHours["minOpenHour"];
            int? maxCloseHour = operatingHours["maxCloseHour"];
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
                          String shopStatus = state.cart[index].shopStatus!;
                          String serviceStatus =
                              state.cart[index].serviceStatus!;

                          final service = state.cart[index];
                          final String serviceId = service.itemId.toString();
                          final noteCon = _controllers.putIfAbsent(
                            serviceId,
                            () => TextEditingController(
                              text: _serviceNotes[serviceId] ?? "",
                            ),
                          );
                          var animation = Tween(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: screenAnimationController,
                                  curve: Interval(0.0, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                          screenAnimationController.forward();
                          bool isSelected =
                              bookingCubit.selectedServices.contains(service);
                          return Stack(children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () => AppNavigator.push(
                                    context,
                                    DetailServicePage(
                                        serviceId:
                                            state.cart[index].serviceId!)),
                                child: BookingCard(
                                  isCart: true,
                                  service: BookingCardViewModel(
                                      status: shopStatus == 'Inactive'
                                          ? shopStatus
                                          : serviceStatus,
                                      imageUrl: state.cart[index].mediaUrl,
                                      city: state.cart[index].city,
                                      district: state.cart[index].district,
                                      duration: state.cart[index].duration,
                                      nameService:
                                          state.cart[index].serviceName!,
                                      price: state.cart[index].price,
                                      shopName: state.cart[index].shopName!),
                                  animationController:
                                      screenAnimationController,
                                  animation: animation,
                                  moreWidget: InkWell(
                                    onTap: () {
                                      if (!bookingCubit.selectedServices
                                          .contains(service)) {
                                        bookingCubit.addService(service);
                                      } else {
                                        bookingCubit.removeService(service);
                                      }
                                      setState(() {
                                        isSelected = bookingCubit
                                            .selectedServices
                                            .contains(service);
                                      });
                                      // if (!isSelected) {
                                      //   setState(() {
                                      //     selectedService.add(service);
                                      //   });
                                      // } else {
                                      //   setState(() {
                                      //     selectedService.remove(state.cart[index]);
                                      //   });
                                      // }
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: !isSelected
                                                ? Colors.blue.shade50
                                                : Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(
                                                AppSize.borderRadiusSmall),
                                            border: Border.all(
                                              color: !isSelected
                                                  ? Colors.blue.shade100
                                                  : Colors.green.shade100,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              !isSelected
                                                  ? Text(
                                                      'Select',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            AppSize.textMedium,
                                                        color: Colors
                                                            .blue.shade500,
                                                      ),
                                                    )
                                                  : Text(
                                                      'Remove',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            AppSize.textMedium,
                                                        color: Colors
                                                            .green.shade500,
                                                      ),
                                                    ),
                                              isSelected
                                                  ? Icon(
                                                      Icons
                                                          .playlist_add_check_sharp,
                                                      size: AppSize.iconSmall,
                                                      color: Colors.black,
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        isSelected
                                            ? SizedBox(
                                                // height: 50,
                                                // width: 200,
                                                child: InputTextFormField(
                                                    controller: noteCon,
                                                    labelText: 'Note',
                                                    hint: 'Note',
                                                    onFieldSubmitted: (value) {
                                                      bookingCubit.updateNote(
                                                          service.itemId
                                                              .toString(),
                                                          value);
                                                    }),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    size: AppSize.iconMedium,
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.background,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<CartItemCubit>()
                                        .deleteCartItem(service.itemId!);
                                  },
                                )),
                          ]);
                        },
                      ),
                    ),
                    state.cart.isEmpty
                        ? SizedBox.shrink()
                        : Positioned(
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
                              child: AddSchedule(
                                openTime: minOpenHour!,
                                closeTime: maxCloseHour!,

                                // cartItem: bookingCubit.selectedServices,
                                // bookingModel: bookingModel,
                              ),
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
