import 'package:Tracio/presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/placeholder/service_card.dart';
import 'package:Tracio/data/shop/models/get_service_req.dart';
import 'package:Tracio/presentation/service/bloc/service_bloc/near_service_cubit/get_near_service_cubit.dart';
import 'package:Tracio/presentation/service/bloc/service_bloc/get_service_cubit.dart';
import 'package:Tracio/presentation/service/bloc/service_bloc/get_service_state.dart';
import 'package:Tracio/presentation/service/widget/custom_search_bar.dart';
import 'package:Tracio/presentation/service/widget/service_grid.dart'
    show ServiceGrid;

import '../bloc/bookingservice/get_booking_detail_cubit/get_booking_detail_cubit.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => GetServiceCubit()
              ..getService(GetServiceReq(
                pageNumberService: 1,
                pageSizeService: 10,
              ))),
        BlocProvider(create: (context) => GetNearServiceCubit()..getNearShop()),
        BlocProvider(create: (context) => GetBookingDetailCubit()),
        BlocProvider(create: (context) => BookingServiceCubit()),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        // appBar: AppBar(
        //   leading: CustomeSearchBar(),
        // ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              CustomSearchBar(),
              SizedBox(
                height: 10.h,
              ),
              // BlocBuilder<GetCategoryCubit, GetCategoryState>(
              //   builder: (context, state) {
              //     if (state is CategoryLoaded) {
              //       return CategoryService(
              //         cateService: state.categories,
              //       );
              //     }
              //     return Center(child: CircularProgressIndicator());
              //   },
              // ),
              SizedBox(
                height: 10.h,
              ),
              BlocBuilder<GetServiceCubit, GetServiceState>(
                builder: (context, state) {
                  if (state is GetServiceLoaded) {
                    return ServiceGrid(
                      services: state.service,
                      // shop: state.shop,
                    );
                  }
                  if (state is GetServiceLoading) {
                    return ServiceCardPlaceHolder();
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
        // bottomNavigationBar: ,
      ),
    );
  }
}
