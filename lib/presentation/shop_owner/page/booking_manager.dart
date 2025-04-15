import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/shop/models/get_booking_req.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_card_view.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_entity.dart';
import 'package:tracio_fe/domain/shop/usecase/get_booking.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_state.dart';
import 'package:tracio_fe/presentation/shop_owner/page/booking_detail_shop.dart';
import 'package:tracio_fe/presentation/shop_owner/widget/booking_card_shop.dart';
import 'package:tracio_fe/service_locator.dart';

import '../../service/widget/booking_card.dart';

// --- Constants for Statuses ---
class BookingStatus {
  static const String pending = 'Pending';
  static const String waiting = 'Waiting';
  static const String rescheduled = 'Rescheduled';
  static const String submitted = 'Submitted';
  static const String processing = 'Processing';
  static const String completed = 'Completed';
  static const String canceled = 'Canceled';
}

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  State<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabTitles = [
    BookingStatus.pending,
    BookingStatus.waiting,
    BookingStatus.rescheduled,
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

    final initialIndex = _tabTitles.indexOf(BookingStatus.pending);
    _tabController = TabController(
      length: _tabTitles.length,
      vsync: this,
      initialIndex: initialIndex >= 0 ? initialIndex : 0,
    );

    // Add listener to detect tab changes
    _tabController.addListener(_handleTabChange);

    // Initial fetch for the first tab (Pending)
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
        backgroundColor: Colors.transparent,
        title: Text(
          'Booking Management',
          style: TextStyle(
            fontSize: AppSize.textLarge,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : Colors.black87,
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
                            userName: booking.userName,
                            status: booking.status,
                            bookingDetailId: booking.bookingDetailId,
                            shopName: booking.shopName,
                            duration: booking.duration,
                            nameService: booking.serviceName,
                            price: booking.price,
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
