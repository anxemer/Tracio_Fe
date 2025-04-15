import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/helper/placeholder/service_card.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/shop/models/get_booking_req.dart';
import 'package:tracio_fe/domain/auth/usecases/logout.dart';
import 'package:tracio_fe/presentation/auth/pages/login.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:tracio_fe/presentation/shop_owner/page/booking_manager.dart';
import 'package:tracio_fe/service_locator.dart';

import '../../../core/configs/theme/assets/app_images.dart';
import '../../service/bloc/get_booking/get_booking_state.dart'; // Để định dạng ngày tháng và tiền tệ

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Dữ liệu giả định cho thông tin shop
  final String _shopImageUrl =
      'https://via.placeholder.com/150/8FBC8F/FFFFFF?Text=Shop';
  final String _shopName = 'Cửa hàng Xe đạp ABC';
  final String _shopAddress = '123 Đường XYZ, Phường Q, Thành phố T';
  final double _shopRating = 4.8;

  // Dữ liệu giả định (thay thế bằng dữ liệu thực tế từ API hoặc database)
  int _totalBookingsToday = 5;
  int _bikesRented = 7;
  int _bikesAvailable = 15;
  double _expectedRevenueToday = 150000;

  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetBookingCubit()..getBooking(GetBookingReq(status: 'Pending')),
        ),
      ],
      child: Scaffold(
        appBar: BasicAppbar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Dashboard',
            style: TextStyle(
                fontSize: AppSize.textHeading,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87),
          ),
        ),
        body: BlocBuilder<GetBookingCubit, GetBookingState>(
          builder: (context, state) {
            if (state is GetBookingLoaded) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Thông tin Shop
                    _buildShopInfoCard(isDark),
                    SizedBox(height: 16.0),

                    Text('Quick stats',
                        style: TextStyle(
                            fontSize: AppSize.textHeading,
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatisticCard(
                          title: 'Booking today',
                          value: state.bookingList.length.toString(),
                          icon: Icons.event,
                          color: Colors.blue,
                        ),
                        _buildStatisticCard(
                          title: 'Service',
                          value: _bikesRented.toString(),
                          icon: Icons.directions_bike,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatisticCard(
                          title: 'Completed booking',
                          value: _bikesAvailable.toString(),
                          icon: Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                        // _buildStatisticCard(
                        //   title: 'Doanh thu dự kiến hôm nay',
                        //   value: _currencyFormat.format(_expectedRevenueToday),
                        //   icon: Icons.attach_money,
                        //   color: Colors.teal,
                        // ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text('Recents Booking',
                        style: TextStyle(
                            fontSize: AppSize.textLarge,
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    state.bookingList.isEmpty
                        ? Text('No recent bookings.')
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.bookingList.length,
                            separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (context, index) {
                              final booking = state.bookingList[index];
                              return ListTile(
                                leading: Icon(Icons.event),
                                title: Text(booking.userName!),
                                subtitle: Text(
                                    '${state.bookingList[index].serviceName}'),
                                trailing: _buildStatusChip(booking.status!),
                                onTap: () {},
                              );
                            },
                          ),
                    SizedBox(height: 24.0),
                    Text('Shortcut Key',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.0),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildQuickActionButton(
                              icon: Icons.book_online,
                              label: 'Booking Management',
                              onTap: () {
                                AppNavigator.push(
                                    context, BookingManagementScreen());
                              },
                            ),
                            _buildQuickActionButton(
                              icon: Icons.directions_bike,
                              label: 'Service Management',
                              onTap: () {
                                // Điều hướng đến màn hình quản lý xe đạp
                                Navigator.pushNamed(context,
                                    '/bicycle_management'); // Đảm bảo bạn đã định nghĩa route này
                              },
                            ),
                          ],
                        ),
                        _buildQuickActionButton(
                          icon: Icons.logout_rounded,
                          label: 'Logout',
                          onTap: () {
                            AppNavigator.pushAndRemove(context, LoginPage());
                            sl<LogoutUseCase>().call(
                                NoParams()); // Đảm bảo bạn đã định nghĩa route này
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (state is GetBookingLoading ||
                state is GetBookingInitial) {
              ServiceCardPlaceHolder();
            }
            return Center(
                child: Column(
              children: [
                Image.asset(
                  AppImages.error,
                  width: AppSize.imageLarge,
                ),
                Text('Can\'t load blog....'),
                IconButton(
                    onPressed: () async {
                      // await context.read<GetBlogCubit>().getBlog(GetBlogReq());
                    },
                    icon: Icon(
                      Icons.refresh_outlined,
                      size: AppSize.iconLarge,
                    ))
              ],
            ));
          },
        ),
      ),
    );
  }

  Widget _buildShopInfoCard(bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: NetworkImage(
                  'https://lh7-rt.googleusercontent.com/docsz/AD_4nXcMWMLZbyQBTasl65xrW2QIMqwAJT6_qzhTFzBk_60iV9K059FPU56_g6ay2OpLNoKtV1WWXNgTptL-fNqaCO0dAohO4kz_rBwbpZpn9hNQdsmwMS_sFTrmz6HKQZsORdJleeeE2sc6S2OfLh-I6aBmbTwP?key=tE_qip6BHPL4g00JXL_X6Q'),
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _shopName,
                    style: TextStyle(
                      fontSize: AppSize.textLarge,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    _shopAddress,
                    style: TextStyle(
                      fontSize: AppSize.textSmall,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16.0),
                      SizedBox(width: 4.0),
                      Text(
                        '${_shopRating.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              SizedBox(height: 8.0),
              Text(title, style: TextStyle(fontSize: 16)),
              Text(value,
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Reschedule':
        color = Colors.yellow;
        break;
      case 'Confirm':
        color = Colors.green;
        break;
      case 'Completed':
        color = Colors.grey;
        break;
      case 'Waiting':
        color = Colors.blueAccent;
        break;
      case 'Canceled':
        color = Colors.redAccent;
        break;
      default:
        color = Colors.black;
    }
    return Chip(
      label: Text(status, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 36, color: Theme.of(context).primaryColor),
          SizedBox(height: 8.0),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// Model dữ liệu đơn giản cho Booking
