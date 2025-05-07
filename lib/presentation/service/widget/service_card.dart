import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/widget/picture/picture.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/shop/entities/response/shop_service_entity.dart';
import 'package:Tracio/presentation/shop_owner/bloc/service_management/service_management_cubit.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../shop_owner/page/create_service.dart';
import '../page/detail_service.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard(
      {super.key, required this.service, this.isShopOwner = false});
  final ShopServiceEntity service;
  final bool isShopOwner;
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: isShopOwner
          ? null
          : () {
              if (service.serviceId != null) {
                AppNavigator.push(
                    context, DetailServicePage(serviceId: service.serviceId!));
              }
            },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black87 : Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: PictureCustom(
                  width: AppSize.imageMedium.w,
                  height: AppSize.imageMedium.h,
                  imageUrl: service.mediaUrl!,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: screenWidth > 360 ? 12.w : 8.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.serviceName ?? 'No Service Name',
                        style: TextStyle(
                          fontSize: AppSize.textMedium.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(height: 4.h),

                      /// Thay thế Row bằng Wrap để tránh tràn
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 4.h,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: AppSize.iconSmall,
                                color: isDark
                                    ? AppColors.secondBackground
                                    : AppColors.background,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                service.formattedDuration,
                                style: TextStyle(fontSize: AppSize.textSmall),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.attach_money_rounded,
                                size: AppSize.iconSmall,
                                color: isDark
                                    ? AppColors.secondBackground
                                    : AppColors.background,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${service.formattedPrice} VNĐ',
                                style: TextStyle(
                                  fontSize: AppSize.textMedium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      if (!isShopOwner)
                        Row(
                          children: [
                            Icon(
                              Icons.storefront_outlined,
                              size: AppSize.iconSmall,
                              color: isDark
                                  ? AppColors.secondBackground
                                  : AppColors.background,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                service.shopName ?? 'No Shop Name',
                                style: TextStyle(
                                  fontSize: AppSize.textSmall,
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),

                      if (isShopOwner) ...[
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                AppNavigator.push(
                                  context,
                                  CreateEditServiceScreen(
                                    isEditing: true,
                                    shopId: service.shopId!,
                                    initialData: service,
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).primaryColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 4.h),
                                minimumSize: Size(0, 30.h),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit,
                                      size: AppSize.iconSmall * 0.9),
                                  SizedBox(width: 3.w),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                        fontSize: AppSize.textSmall * 0.95),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w),
                            TextButton(
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, service);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 4.h),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size(0, 30.h),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.delete_outline,
                                      size: AppSize.iconSmall * 0.9),
                                  SizedBox(width: 3.w),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                        fontSize: AppSize.textSmall * 0.95),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, ShopServiceEntity service) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to delete the service "${service.serviceName ?? 'this'}"?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete'),
              onPressed: () {
                context
                    .read<ServiceManagementCubit>()
                    .deleteService(service.serviceId);
                // Gọi API hoặc phương thức xóa
                print('Confirmed delete for service: ${service.serviceId}');
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
