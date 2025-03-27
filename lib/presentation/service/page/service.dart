import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tracio_fe/common/bloc/generic_data_cubit.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/shop/entities/service_response_entity.dart';
import 'package:tracio_fe/domain/shop/usecase/get_service.dart';
import 'package:tracio_fe/presentation/blog/bloc/category/get_category_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/category/get_category_state.dart';
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
                  if (state is DataLoading) {
                    return Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.black38,
                          highlightColor: Colors.black87,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Expanded(
                          child: Shimmer.fromColors(
                            baseColor: Colors.black38,
                            highlightColor: Colors.black54,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 160,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.black26,
                                  ),
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                Row(
                                  children: [82, 24].asMap().entries.map((e) {
                                    return Container(
                                      width: e.value.toDouble(),
                                      height: 24,
                                      margin: EdgeInsets.only(
                                          left: e.key == 0 ? 0 : 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.black26,
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(2, (index) {
                                    return Container(
                                      width: double.infinity,
                                      height: 12,
                                      margin: EdgeInsets.only(
                                          top: index == 0 ? 0 : 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.black26,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
