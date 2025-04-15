import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/shop/entities/response/booking_card_view.dart';

import '../../../core/configs/theme/app_colors.dart';

class BookingCardShop extends StatefulWidget {
  const BookingCardShop(
      {super.key,
      this.moreWidget,
      required this.service,
      this.imageSize,
      this.backgroundColor,
      this.ontap});

  final Widget? moreWidget;
  final BookingCardViewModel service; // Ensure service has a 'status' field

  final double? imageSize;
  final Color? backgroundColor;
  final VoidCallback? ontap;
  @override
  State<BookingCardShop> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCardShop> {
  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    // Pass the status to _buildCardContent or access directly via widget.service.status
    return _buildCardContent(isDark, widget.service.status);
  }

  Widget _buildCardContent(bool isDark, String? status) {
    // Add status parameter
    return Card(
      color: widget.backgroundColor,
      margin: const EdgeInsets.all(0),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                InkWell(
                  onTap: widget.ontap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          AppImages
                              .picture, // Should replace with actual image from service if available
                          width: widget.imageSize ?? AppSize.imageMedium.w,
                          height:
                              widget.imageSize ?? AppSize.imageMedium.h * .8,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            // Add fallback for image error
                            width: widget.imageSize ?? AppSize.imageMedium.w,
                            height:
                                widget.imageSize ?? AppSize.imageMedium.h * .8,
                            color: Colors.grey.shade300,
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.start, // Or center as desired
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.service.nameService ??
                                  'N/A', // Handle null
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSize.textLarge.sp,
                                color: isDark
                                    ? Colors.grey.shade300
                                    : Colors.black87,
                              ),
                              maxLines:
                                  2, // Limit lines if the name is too long
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5.h, // Reduce spacing if needed
                            ),
                            // --- Row containing Price and Duration ---
                            Row(
                              children: [
                                if (widget.service.price != null)
                                  _buildInfoRow(
                                    icon: Icons.attach_money_rounded,
                                    text: '${widget.service.formattedPrice} \$',
                                    isDark: isDark,
                                  ),
                                if (widget.service.price != null &&
                                    widget.service.duration != null)
                                  SizedBox(
                                      width: 15
                                          .w), // Space between price and duration
                                if (widget.service.duration != null)
                                  _buildInfoRow(
                                    icon: Icons.access_time_rounded,
                                    text: widget.service.formattedDuration,
                                    isDark: isDark,
                                    iconSpacing: 4.w,
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h, // Reduce spacing
                            ),
                            // --- Row containing Staff Name (Example) ---
                            _buildInfoRow(
                              icon: Icons
                                  .person_outline, // Different icon if needed
                              text: widget.service.userName ??
                                  'An Xểm', // Should get from service if available
                              isDark: isDark,
                              iconSpacing: 4.w,
                              textColor: isDark
                                  ? Colors.white
                                  : Colors.black87, // Clearer text color
                            ),
                            // --- Booking Date/Time Row ---
                            if (widget.service.bookedDate != null) ...[
                              SizedBox(height: 5.h), // Reduce spacing
                              _buildInfoRow(
                                icon: Icons.schedule_outlined,
                                text: DateFormat('dd/MM/yyyy HH:mm')
                                    .format(widget.service.bookedDate!),
                                isDark: isDark,
                                iconSpacing: 4.w,
                                textColor: isDark
                                    ? Colors.white70
                                    : Colors.black54, // Secondary text color
                              ),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                // --- Additional Widget (if any) ---

                widget.moreWidget ?? Container()
              ],
            ),
          ),

          // --- Layer containing Status Badge ---
          if (status != null &&
              status.isNotEmpty) // Only display if status exists
            Positioned(
              top: 10.0, // Distance from the top edge of the Card
              right: 10.0, // Distance from the right edge of the Card
              child: _buildStatusBadge(status, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required bool isDark,
    double iconSpacing = 0, // Space between icon and text
    Color? textColor,
  }) {
    final defaultTextColor =
        isDark ? Colors.grey.shade300 : Colors.grey.shade700;
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center, // Vertically center icon and text
      children: [
        Icon(
          icon,
          size: AppSize.iconMedium * 0.9, // Slightly smaller icon
          color: isDark
              ? AppColors.secondBackground
              : AppColors.background, // Use color from theme
        ),
        SizedBox(width: iconSpacing),
        Text(
          text,
          style: TextStyle(
            fontSize: AppSize.textMedium * 0.95, // Slightly smaller text
            color: textColor ?? defaultTextColor, // Prioritize passed-in color
          ),
        ),
      ],
    );
  }

  // --- Widget to create the Status Badge ---
  Widget _buildStatusBadge(String status, bool isDark) {
    Color badgeColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'Pending': // Add variations if needed
        badgeColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'cancelled': // Add variations if needed
        badgeColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      case 'completed':
        badgeColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'Waiting':
        badgeColor = Colors.yellow.shade100;
        textColor = Colors.yellow.shade800;
        break;
      case 'Submitted':
        badgeColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      default: // Default or unknown status
        badgeColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 8.w, vertical: 3.h), // Adjust padding
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(
            AppSize.borderRadiusSmall / 2), // Softer corner radius
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500, // Medium weight
          fontSize: AppSize.textSmall.sp, // Small font size
        ),
      ),
    );
  }
}
