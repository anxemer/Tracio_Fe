import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/shop/models/get_booking_req.dart';
import 'package:Tracio/domain/shop/entities/response/booking_card_view.dart';
import 'package:Tracio/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:Tracio/presentation/service/bloc/get_booking/get_booking_state.dart';
import 'package:Tracio/presentation/shop_owner/page/booking_detail_shop.dart';
import 'package:Tracio/presentation/shop_owner/widget/booking_card_shop.dart';

import '../../service/widget/booking_status_tab.dart';

// --- Constants for Statuses ---
class BookingStatus {
  static const String pending = 'Pending';
  static const String reschedule = 'Reschedule';
  static const String submitted = 'Confirmed';
  static const String processing = 'Processing';
  static const String completed = 'Completed';
  static const String canceled = 'Cancelled';
}

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({super.key, this.initialIndex = 0});
  final int initialIndex;
  @override
  State<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabTitles = [
    BookingStatus.pending,
    BookingStatus.reschedule,
    BookingStatus.submitted,
    BookingStatus.processing,
    BookingStatus.completed,
    BookingStatus.canceled,
  ];

  // Current status being displayed
  String _currentStatus = BookingStatus.pending;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: _tabTitles.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _currentStatus = _tabTitles[widget.initialIndex];

    _tabController.addListener(_handleTabChange);

    _fetchBookingsByStatus(_currentStatus);
  }

  // Handle tab changes and fetch appropriate data
  void _handleTabChange() {
    if (_tabController.indexIsChanging ||
        _tabController.index != _tabController.previousIndex) {
      setState(() {
        _currentStatus = _tabTitles[_tabController.index];
      });
      _fetchBookingsByStatus(_currentStatus);
    }
  }

  // Fetch bookings filtered by status from API
  void _fetchBookingsByStatus(String status) {
    if (mounted) {
      // Create request with status parameter
      final GetBookingReq request = GetBookingReq(
        status: status, // Assuming GetBookingReq has a status field
      );

      // Call cubit with status filter
      context.read<GetBookingCubit>().getBooking(request);
    }
  }

  // Refresh current tab data
  void _refreshCurrentTab() {
    _fetchBookingsByStatus(_currentStatus);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Booking Management',
          style: TextStyle(
            fontSize: AppSize.textLarge,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        action: IconButton(
          icon: Icon(Icons.refresh,
              color: isDark ? Colors.white70 : Colors.black87),
          tooltip: 'Refresh Bookings',
          onPressed: _refreshCurrentTab,
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
          ),
          Expanded(
            child: BlocBuilder<GetBookingCubit, GetBookingState>(
              builder: (context, state) {
                if (state is GetBookingLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GetBookingFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Failed to load ${_currentStatus.toLowerCase()} bookings: ${state.message}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            onPressed: _refreshCurrentTab,
                          )
                        ],
                      ),
                    ),
                  );
                }

                if (state is GetBookingLoaded) {
                  final bookings = state.bookingList;

                  if (bookings.isEmpty) {
                    return Center(
                      child: Text(
                        'No $_currentStatus bookings found.',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  // Now we just show the bookings we received from the API
                  // No client-side filtering needed since API is sending filtered data
                  return ListView.builder(
                    key: PageStorageKey(_currentStatus),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BookingCardShop(
                          ontap: () => AppNavigator.push(
                              context,
                              BookingDetailShopScreen(
                                  bookingId: booking.bookingDetailId!)),
                          service: BookingCardViewModel(
                            imageUrl: booking.serviceMediaFile!,
                            userName: booking.cyclistName,
                            status: booking.status,
                            bookingDetailId: booking.bookingDetailId,
                            shopName: booking.shopName,
                            duration: booking.duration,
                            nameService: booking.serviceName,
                            price: booking.price,
                          ),
                          moreWidget: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: getStatusColor(
                                  state.bookingList[index].status!),
                              borderRadius: BorderRadius.circular(
                                  AppSize.borderRadiusSmall),
                              border: Border.all(
                                color: getStatusBorderColor(
                                    state.bookingList[index].status!),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.bookingList[index].status!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppSize.textMedium,
                                    color: Colors.black87,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                // Initial state
                return const Center(child: Text('Loading bookings...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
