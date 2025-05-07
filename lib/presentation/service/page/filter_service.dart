import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/bloc/filter_cubit.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/shop/models/get_service_req.dart';
import 'package:Tracio/domain/shop/entities/response/shop_service_entity.dart';
import 'package:Tracio/presentation/service/bloc/service_bloc/get_service_cubit.dart';
import 'package:Tracio/presentation/service/widget/service_card.dart';

import '../bloc/service_bloc/get_service_state.dart';
import '../widget/filter_view.dart';

class FilterServicePage extends StatefulWidget {
  const FilterServicePage(
      {super.key,
      this.shouldAutoFocus = true,
      required this.shouldFetchAllServices,
      this.shopId});
  // final List<ShopServiceEntity> services;
  final bool shouldAutoFocus;
  final bool shouldFetchAllServices;
  final int? shopId;
  @override
  State<FilterServicePage> createState() => _FilterServicePageState();
}

class _FilterServicePageState extends State<FilterServicePage> {
  bool isFilter = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  @override
  void initState() {
    if (widget.shouldFetchAllServices) {
      context.read<GetServiceCubit>().getService(GetServiceReq());
    }
    if (widget.shouldAutoFocus) {
      context.read<GetServiceCubit>().resetState();
      Future.delayed(Duration(milliseconds: 300), () {
        _searchFocusNode.requestFocus();
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return BlocProvider(
      create: (context) => FilterCubit(),
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: AppSize.apVerticalPadding.h, horizontal: 4.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_rounded)),
                      // SizedBox(
                      //   width: 8.w,
                      // ),
                      Expanded(
                        child: BlocBuilder<FilterCubit, GetServiceReq>(
                          builder: (context, state) {
                            return TextField(
                              focusNode: _searchFocusNode,
                              // autofocus: true,
                              // onTap: () =>
                              //     AppNavigator.push(context, FilterServicePage()),
                              controller:
                                  context.read<FilterCubit>().searchController,
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              onChanged: (value) => setState(() {}),
                              onSubmitted: (value) {
                                setState(() {});
                                context.read<GetServiceCubit>().getService(
                                    GetServiceReq(
                                        keyword: value, shopId: widget.shopId));
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.transparent,
                                prefixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.search_outlined),
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          context
                                              .read<FilterCubit>()
                                              .searchController
                                              .clear();
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.close),
                                      )
                                    : null,
                                hintText: "Search service",
                                hintStyle: TextStyle(
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : Colors.grey[400]),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 10.w),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0.r)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0.r)),
                                    borderSide: BorderSide(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.grey.shade600)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0.r)),
                                    borderSide: BorderSide(
                                        color: isDark
                                            ? AppColors.secondBackground
                                            : AppColors.background)),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isFilter = !isFilter;
                          });
                        },
                        child: Container(
                          height: 32.h,
                          width: 32.h,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkGrey
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.tune,
                              color: isDark
                                  ? AppColors.secondBackground
                                  : AppColors.background,
                              size: AppSize.iconMedium.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  isFilter ? FilterView() : Container()
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: BlocBuilder<GetServiceCubit, GetServiceState>(
                builder: (context, state) {
                  if (state is GetServiceLoaded) {
                    return _buildSearchResults(state.service);
                    // return Center(child: Text("Search Service"));
                    // Hiển thị danh sách
                  } else if (state is GetServiceLoading) {
                    return Center(
                        child: CircularProgressIndicator()); // Hiển thị loading
                  } else {
                    return Center(child: Text("Search Service"));
                  }
                },
              ),
            )
          ],
        )),
      ),
    );
  }

  // Giao diện hiển thị kết quả tìm kiếm
  Widget _buildSearchResults(List<ShopServiceEntity> services) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3,
              mainAxisSpacing: 16.h,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ServiceCard(service: services[index]);
              },
              childCount: services.length,
            ),
          ),
        ),
      ],
    );
  }
}
