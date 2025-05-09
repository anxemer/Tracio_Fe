import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/bloc/generic_data_cubit.dart';
import 'package:Tracio/common/bloc/generic_data_state.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/groups/models/response/vietnam_city_model.dart';
import 'package:Tracio/domain/groups/usecases/get_city_usecase.dart';
import 'package:Tracio/presentation/groups/cubit/form_group_cubit.dart';
import 'package:Tracio/presentation/groups/widgets/group_location_select.dart';
import 'package:Tracio/service_locator.dart';

class GroupLocationStep extends StatefulWidget {
  const GroupLocationStep({super.key});

  @override
  State<GroupLocationStep> createState() => _GroupLocationStepState();
}

class _GroupLocationStepState extends State<GroupLocationStep> {
  @override
  void initState() {
    Future.microtask(() {
      context
          .read<GenericDataCubit>()
          .getData<List<VietnamCityModel>>(sl<GetCityUsecase>());
    });
    super.initState();
  }

  //TODO Reverse geolocation current position
  //TODO: Change location

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          "Where is your group located?",
          style: TextStyle(
            fontSize: AppSize.textHeading.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSize.apVerticalPadding),

        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.apHorizontalPadding,
            vertical: AppSize.apVerticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.my_location_sharp,
                size: AppSize.iconMedium,
                color: Colors.black,
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: BlocBuilder<FormGroupCubit, FormGroupState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.groupRequest.city != ''
                              ? state.groupRequest.city
                              : "Thành Phố Dĩ An",
                          style: TextStyle(
                            fontSize: AppSize.textLarge.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          state.groupRequest.city != '' &&
                                  state.groupRequest.district != ''
                              ? '${state.groupRequest.city}, ${state.groupRequest.district}'
                              : "Thành phố Dĩ An, Bình Dương",
                          style: TextStyle(
                            fontSize: AppSize.textSmall.sp,
                            color: Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  showLocationModal(context, context.read<FormGroupCubit>());
                },
                child: Text(
                  "Change",
                  style: TextStyle(
                    fontSize: AppSize.textSmall.sp,
                    color: AppColors.secondBackground,
                  ),
                ),
              )
            ],
          ),
        ),

        SizedBox(height: AppSize.apVerticalPadding),

        Divider(color: Colors.grey.shade400),
        // Footer Text
        Align(
          alignment: Alignment.center,
          child: Text(
            "You can always change this later",
            style: TextStyle(
              fontSize: AppSize.textSmall.sp,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(height: AppSize.apVerticalPadding),
      ],
    );
  }

  void showLocationModal(BuildContext context, FormGroupCubit formGroupCubit) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider(
          create: (context) => GenericDataCubit()
            ..getData<List<VietnamCityModel>>(sl<GetCityUsecase>()),
          child: BlocBuilder<GenericDataCubit, GenericDataState>(
            builder: (context, state) {
              if (state is DataLoading) {
                return CircularProgressIndicator();
              }

              if (state is DataLoaded) {
                return FractionallySizedBox(
                    heightFactor: 0.9,
                    child: GroupLocationSelect(cubit: formGroupCubit));
              }

              if (state is FailureLoadData) {
                return Container(
                  height: 50,
                  width: 50,
                  color: Colors.red,
                );
              }

              return SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
