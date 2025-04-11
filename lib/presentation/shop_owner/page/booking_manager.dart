import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart'; // Assuming BasicAppbar exists
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/shop/models/get_booking_req.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_card_view.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_entity.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/get_booking/get_booking_state.dart';
import 'package:tracio_fe/presentation/shop_owner/page/booking_detail_shop.dart';
import 'package:tracio_fe/presentation/shop_owner/widget/booking_card_shop.dart';

import '../../service/widget/booking_card.dart';
// !<- IMPORT YOUR BookingCard WIDGET

// --- Constants for Statuses (Recommended for consistency) ---
class BookingStatus {
  static const String pending = 'Pending';
  static const String waiting = 'Waiting';
  static const String rescheduled = 'Rescheduled'; // Corrected spelling
  static const String submitted = 'Submitted';
  static const String processing = 'Processing';
  static const String completed = 'Completed';
  static const String canceled = 'Canceled'; // Ensure this tab exists if needed
  // Add other statuses if required
}

class BookingManagementScreen extends StatefulWidget {
  // Add const constructor
  const BookingManagementScreen({super.key});

  @override
  State<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Define tab titles using constants
  final List<String> _tabTitles = [
    BookingStatus.pending,
    BookingStatus.waiting,
    BookingStatus.rescheduled,
    BookingStatus.submitted,
    BookingStatus.processing,
    BookingStatus.completed,
    BookingStatus.canceled, // Make sure this matches your API/UI needs
  ];

  @override
  void initState() {
    super.initState();

    // Initialize TabController
    final initialIndex = _tabTitles.indexOf(BookingStatus.pending);
    _tabController = TabController(
      length: _tabTitles.length,
      vsync: this,
      initialIndex: initialIndex >= 0 ? initialIndex : 0,
    );
    context.read<GetBookingCubit>().getBooking(GetBookingReq());
    // --- Fetch initial data using the Cubit ---
    // Ensure GetBookingCubit is provided above this widget in the tree
    // This assumes fetchAllBookings gets all statuses needed for the tabs
    _fetchBookings(); // Call helper method
  }

  void _fetchBookings() {
    // Ensure context is mounted before accessing BlocProvider
    if (mounted) {
      // context.read<GetBookingCubit>().fetchAllBookings(); // Adjust method name if needed
    }
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose controller
    super.dispose();
  }

  // Helper function to filter bookings based on status
  // Takes the list from the Cubit state as input
  List<BookingEntity> _filterBookingsByStatus(
      String status, List<BookingEntity> allBookings) {
    return allBookings
        .where((booking) =>
            booking.status?.toLowerCase() ==
            status.toLowerCase()) // Use null-safe access for status
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Scaffold(
      appBar: BasicAppbar(
        // Use your AppBar widget
        backgroundColor: Colors.transparent, // Example customization
        title: Text(
          'Booking Management',
          style: TextStyle(
            fontSize: AppSize.textLarge, // Use constant
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        action: // Optional: Add a refresh button
            IconButton(
          icon: Icon(Icons.refresh,
              color: isDark ? Colors.white70 : Colors.black87),
          tooltip: 'Refresh Bookings',
          onPressed: _fetchBookings, // Call fetch again
        ),
      ),
      body: Column(
        // Use Column for TabBar + Expanded(BlocBuilder)
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true, // Allows tabs to scroll if many exist
            tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
            // You can customize indicatorColor, labelColor etc. here
            // e.g., indicatorColor: Theme.of(context).primaryColor,
          ),
          Expanded(
            // Use BlocBuilder to react to state changes from GetBookingCubit
            child: BlocBuilder<GetBookingCubit, GetBookingState>(
              builder: (context, state) {
                // --- Handle different states ---

                if (state is GetBookingLoading) {
                  // Show a loading indicator centered
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GetBookingFailure) {
                  // Show error message and a retry button
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Failed to load bookings: ${state.message}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            onPressed: _fetchBookings, // Retry fetching
                          )
                        ],
                      ),
                    ),
                  );
                }

                if (state is GetBookingLoaded) {
                  // Data loaded successfully, get the list
                  // This list contains ALL bookings returned by fetchAllBookings
                  final allBookings = state.bookingList;

                  // Handle case where API returns success but the list is empty
                  if (allBookings.isEmpty) {
                    return const Center(
                        child: Text(
                      'No bookings found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ));
                  }

                  // Build the TabBarView with filtered lists for each tab
                  return TabBarView(
                    controller: _tabController,
                    children: _tabTitles.map((title) {
                      // Filter the loaded bookings for the current tab's status
                      final filteredBookings =
                          _filterBookingsByStatus(title, allBookings);

                      if (filteredBookings.isEmpty) {
                        // Display empty message specific to this tab
                        return Center(
                          child: Text(
                            'No $title bookings.', // Simpler empty message
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        // Display the list of bookings for this tab
                        return ListView.builder(
                          key: PageStorageKey(
                              title), // Helps preserve scroll position
                          // Use constant
                          itemCount: filteredBookings.length,
                          itemBuilder: (context, index) {
                            final booking = filteredBookings[index];
                            // ! Use the dedicated BookingCard widget here
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BookingCardShop(
                                ontap: () => AppNavigator.push(
                                    context,
                                    BookingDetailShopScreen(
                                        bookingId: booking.bookingDetailId!)),
                                service: BookingCardViewModel(
                                    status: booking.status,
                                    bookingDetailId: booking.bookingDetailId,
                                    shopName: booking.shopName,
                                    duration: booking.duration,
                                    nameService: booking.serviceName,
                                    price: booking.price),
                              ),
                            );
                          },
                        );
                      }
                    }).toList(),
                  );
                }

                // Handle Initial state or any other unexpected state
                return const Center(
                    child: Text(
                        'Loading bookings...')); // Or specific initial widget
              },
            ),
          ),
        ],
      ),
    );
  }

  String _capitalizeStatus(String? status) {
    if (status == null || status.isEmpty) return '';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  Color _getStatusBackgroundColor(String? status) {
    // Copy logic switch case từ các ví dụ trước vào đây
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange[100] ?? Colors.grey[200]!;
      case 'waiting':
        return Colors.yellow[100] ?? Colors.grey[200]!;
      case 'rescheduled':
        return Colors.blue[100] ?? Colors.grey[200]!;
      case 'submitted':
        return Colors.blue[100] ?? Colors.grey[200]!;
      case 'confirmed':
        return Colors.cyan[100] ?? Colors.grey[200]!;
      case 'processing':
        return Colors.purple[100] ?? Colors.grey[200]!;
      case 'completed':
        return Colors.green[100] ?? Colors.grey[200]!;
      case 'canceled':
        return Colors.red[100] ?? Colors.grey[200]!;
      default:
        return Colors.grey[300]!;
    }
  }

  Color _getStatusTextColor(String? status) {
    // Copy logic switch case từ các ví dụ trước vào đây
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange[800] ?? Colors.grey[800]!;
      case 'waiting':
        return Colors.yellow[800] ?? Colors.grey[800]!;
      case 'rescheduled':
        return Colors.blue[800] ?? Colors.grey[800]!;
      case 'submitted':
        return Colors.blue[800] ?? Colors.grey[800]!;
      case 'confirmed':
        return Colors.cyan[800] ?? Colors.grey[800]!;
      case 'processing':
        return Colors.purple[800] ?? Colors.grey[800]!;
      case 'completed':
        return Colors.green[800] ?? Colors.grey[800]!;
      case 'canceled':
        return Colors.red[800] ?? Colors.grey[800]!;
      default:
        return Colors.grey[800]!;
    }
  }
  // --- Remove the old _buildBookingCard method from this file ---
  // --- Ensure helper methods (_capitalizeStatus, _getStatusBackgroundColor, etc.)
  // --- are part of the BookingCard widget or a separate utility file.
}
