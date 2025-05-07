import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/button/button.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/shop/models/get_service_req.dart';
import 'package:Tracio/presentation/shop_owner/page/create_service.dart';

import '../../../common/helper/placeholder/service_card.dart';
import '../../service/bloc/service_bloc/get_service_cubit.dart';
import '../../service/bloc/service_bloc/get_service_state.dart';
import '../../service/widget/custom_search_bar.dart';
import '../../service/widget/service_grid.dart';

class ServiceManagementPage extends StatefulWidget {
  const ServiceManagementPage({super.key, required this.shopId});
  final int shopId;
  @override
  State<ServiceManagementPage> createState() => _ServiceManagementPageState();
}

class _ServiceManagementPageState extends State<ServiceManagementPage> {
  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return BlocProvider(
      create: (context) =>
          GetServiceCubit()..getService(GetServiceReq(shopId: widget.shopId)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        // appBar: AppBar(
        //   leading: CustomeSearchBar(),
        // ),
        body: RefreshIndicator(
          onRefresh: () async {
            context
                .read<GetServiceCubit>()
                .getService(GetServiceReq(shopId: widget.shopId));
          },
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                CustomSearchBar(
                  isShopOwner: true,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: ButtonDesign(
                    textColor: Colors.white70,
                    width: 100.w,
                    ontap: () {
                      AppNavigator.push(context,
                        CreateEditServiceScreen(shopId: widget.shopId));
                    },
                    fillColor: AppColors.primary,
                    borderColor: Colors.transparent,
                    fontSize: AppSize.textMedium,
                    text: 'Add',
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                    ),
                    iconSize: AppSize.iconLarge,
                  ),
                ),

                BlocBuilder<GetServiceCubit, GetServiceState>(
                  builder: (context, state) {
                    if (state is GetServiceLoaded) {
                      return ServiceGrid(
                        isShopOwner: true,
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
        ),
        // bottomNavigationBar: ,
      ),
    );
  }
}
