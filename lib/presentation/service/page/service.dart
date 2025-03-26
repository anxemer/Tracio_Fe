import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/bloc/generic_data_cubit.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/blog/entites/category.dart';
import 'package:tracio_fe/domain/shop/entities/booking_entity.dart';
import 'package:tracio_fe/domain/shop/entities/service_response_entity.dart';
import 'package:tracio_fe/domain/shop/entities/shop_service_entity.dart';
import 'package:tracio_fe/domain/shop/usecase/get_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/get_cart_item.dart';
import 'package:tracio_fe/domain/shop/usecase/get_cate_service.dart';
import 'package:tracio_fe/domain/shop/usecase/get_service.dart';
import 'package:tracio_fe/presentation/blog/bloc/category/get_category_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/category/get_category_state.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/cart_item_bloc/cart_item_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:tracio_fe/presentation/service/widget/category_service.dart';
import 'package:tracio_fe/presentation/service/widget/custom_search_bar.dart';
import 'package:tracio_fe/presentation/service/widget/service_grid.dart'
    show ServiceGrid;

import '../../../common/bloc/generic_data_state.dart';
import '../../../service_locator.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GenericDataCubit()
            ..getData<ServiceResponseEntity>(sl<GetServiceUseCase>(),
                params: NoParams()),
        ),
        BlocProvider(
            create: (context) => GetCategoryCubit()..getCategoryService()),
        
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              BlocBuilder<GetCategoryCubit, GetCategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoaded) {
                    return CategoryService(
                      cateService: state.categories,
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              BlocBuilder<GenericDataCubit, GenericDataState>(
                builder: (context, state) {
                  if (state is DataLoaded) {
                    return ServiceGrid(
                      services: state.data,
                    );
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
