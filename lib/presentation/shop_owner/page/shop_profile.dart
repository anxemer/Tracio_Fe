import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/shop/entities/response/shop_profile_entity.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/shop_owner/bloc/shop_profile/shop_profile_manage/shop_profile_manage_cubit.dart';
import 'package:Tracio/presentation/shop_owner/page/shop_profile_management.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../auth/bloc/authCubit/auth_cubit.dart';
import '../../auth/pages/login.dart';

class ShopOwnerProfileScreen extends StatelessWidget {
  const ShopOwnerProfileScreen({super.key, required this.shopProfile});
  final ShopProfileEntity shopProfile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    var isDark = context.isDarkMode;
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Shop profile',
          style: TextStyle(
              fontSize: AppSize.textHeading, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent, // Màu nền AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                spacing: 20.h,
                children: [
                  CirclePicture(
                      imageUrl: shopProfile.profilePicture!,
                      imageSize: AppSize.imageSmall.sp),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSize.apHorizontalPadding * .8.h),
                    height: 28,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: AppColors.secondBackground),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: isDark
                              ? AppColors.secondBackground
                              : AppColors.background,
                          size: AppSize.iconMedium,
                        ),
                        Text(
                          '${shopProfile.openTime!.substring(0, 5)} - ${shopProfile.closedTime!.substring(0, 5)}',
                          style: TextStyle(
                            color:
                                isDark ? Colors.grey.shade300 : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: AppSize.textMedium,
                          ),
                        ),
                      ],
                    ),
                  )
                  // CircleAvatar(
                  //   radius: 50, // Kích thước ảnh đại diện
                  //   backgroundImage: NetworkImage(
                  //       'https://api.xedap.vn/wp-content/uploads/2023/01/xe-dap-tphcm.jpg'),
                  //   backgroundColor: Colors.grey.shade300,
                  // ),
                  // const SizedBox(height: 12.0),
                  // Text(
                  //   shopProfile.,
                  //   style: textTheme.headlineSmall
                  //       ?.copyWith(fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(height: 4.0),
                  // Text(
                  //   'An Xểm Shop owner', // Tên cửa hàng hoặc vai trò
                  //   style: textTheme.titleMedium
                  //       ?.copyWith(color: Colors.grey.shade600),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildInfoTile(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      subtitle: 'anxemershop@gmail.com',
                      context: context,
                    ),
                    const Divider(indent: 16, endIndent: 16),
                    _buildInfoTile(
                      icon: Icons.phone_outlined,
                      title: 'Phone Number',
                      subtitle: shopProfile.contactNumber!,
                      context: context,
                    ),
                    const Divider(indent: 16, endIndent: 16),
                    _buildInfoTile(
                      icon: Icons.store_outlined,
                      title: 'Shop',
                      subtitle: '${shopProfile.shopName} - Xem chi tiết',
                      trailingIcon: Icons.arrow_forward_ios,
                      context: context,
                      onTap: () {},
                    ),
                    const Divider(indent: 16, endIndent: 16),
                    _buildInfoTile(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      subtitle:
                          '${shopProfile.address} - ${shopProfile.district} - ${shopProfile.city}',
                      context: context,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16.0),
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildActionTile(
                      icon: Icons.edit_outlined,
                      title: 'Edit Profile',
                      context: context,
                      onTap: () async {
                        final result =
                            await Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider<MapCubit>(
                                  create: (context) => MapCubit(),
                                ),
                                BlocProvider(
                                  create: (context) => ShopProfileManageCubit(),
                                ),
                              ],
                              child: ShopProfileManagementScreen(
                                isEditing: true,
                                initialData: shopProfile,
                              ),
                            );
                          },
                        ));

                        if (result) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Edit Shop Profile Success!')),
                          );
                        }
                      },
                    ),
                    // const Divider(indent: 16, endIndent: 16),
                    // _buildActionTile(
                    //   icon: Icons.settings_outlined,
                    //   title: 'Cài đặt tài khoản',
                    //   context: context,
                    //   onTap: () {
                    //     // TODO: Điều hướng đến trang cài đặt
                    //     print('Đi đến cài đặt');
                    //   },
                    // ),
                    const Divider(indent: 16, endIndent: 16),
                    _buildActionTile(
                      icon: Icons.help_outline,
                      title: 'Helper',
                      context: context,
                      onTap: () {
                        // TODO: Điều hướng đến trang trợ giúp
                        print('Đi đến trợ giúp');
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // --- Nút Đăng xuất ---
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: _buildActionTile(
                icon: Icons.logout,
                title: 'Logout',
                iconColor: colorScheme.error,
                textColor: colorScheme.error,
                context: context,
                onTap: () {
                  context.read<AuthCubit>().logout();
                  AppNavigator.pushAndRemove(context, LoginPage());
                },
                showTrailingIcon: false, // Không cần mũi tên cho Đăng xuất
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    IconData? trailingIcon,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title, style: textTheme.titleMedium),
      subtitle: Text(
        subtitle,
        style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
      ),
      trailing: trailingIcon != null
          ? Icon(trailingIcon, size: 16, color: Colors.grey)
          : null, // Icon bên phải (nếu có)
      onTap: onTap, // Hàm xử lý khi nhấn vào
      dense: true, // Giảm khoảng cách dọc của ListTile
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    Color? iconColor,
    Color? textColor,
    required BuildContext context,
    required VoidCallback onTap,
    bool showTrailingIcon = true,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: iconColor ?? colorScheme.primary),
      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(color: textColor),
      ),
      trailing: showTrailingIcon
          ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          : null,
      onTap: onTap,
      dense: true,
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Login'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to log out of this account?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Đóng hộp thoại
              },
            ),
            TextButton(
              child: Text('Logout',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () {
                // TODO: Thêm logic đăng xuất thực tế ở đây
                Navigator.of(dialogContext).pop(); // Đóng hộp thoại
                // Ví dụ: Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        );
      },
    );
  }
}
