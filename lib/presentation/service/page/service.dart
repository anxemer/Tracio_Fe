import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/data/shop/models/get_service_req.dart';
import 'package:tracio_fe/presentation/service/bloc/service_bloc/cubit/get_near_service_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/service_bloc/get_service_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/service_bloc/get_service_state.dart';
import 'package:tracio_fe/presentation/service/widget/custom_search_bar.dart';
import 'package:tracio_fe/presentation/service/widget/service_grid.dart'
    show ServiceGrid;

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
