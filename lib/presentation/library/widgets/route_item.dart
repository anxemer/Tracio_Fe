import 'package:flutter/material.dart';
import 'package:tracio_fe/domain/map/entities/route.dart';
import 'package:tracio_fe/presentation/library/pages/edit_route_planned.dart';

class RouteItem extends StatefulWidget {
  final RouteEntity routeData;

  const RouteItem({super.key, required this.routeData});

  @override
  State<RouteItem> createState() => _RouteItemState();
}

class _RouteItemState extends State<RouteItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Route Thumbnail (Left Side)
          ClipRRect(
            borderRadius: BorderRadius.circular(8), // Rounded corners
            child: Image.network(
              widget.routeData.routeThumbnail,
              width: 60,
              height: 60,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: 80, color: Colors.grey),
            ),
          ),

          const SizedBox(width: 12), // Space between image and text

          /// Route Information (Right Side)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.routeData.routeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  "Cyclist: ${widget.routeData.cyclistName}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            offset: Offset(-30, 30),
            color: Colors.white,
            elevation: 1,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              _handleMenuAction(value);
            },
            itemBuilder: (context) => [
              _buildPopupMenuItem("Share", Icons.share),
              _buildPopupMenuItem("Navigate", Icons.directions),
              _buildPopupMenuItem("Edit Details", Icons.edit),
              _buildPopupMenuItem("Download for Offline", Icons.download),
              _buildPopupMenuItem("Delete from Library", Icons.delete,
                  isDestructive: true),
            ],
          ),
        ],
      ),
    );
  }

  /// Creates a menu item with icon & text
  PopupMenuItem<String> _buildPopupMenuItem(String text, IconData icon,
      {bool isDestructive = false}) {
    return PopupMenuItem(
      value: text,
      child: Row(
        children: [
          Icon(icon, color: isDestructive ? Colors.red : Colors.black54),
          const SizedBox(width: 10),
          Text(text,
              style: TextStyle(
                  color: isDestructive ? Colors.red : Colors.black45)),
        ],
      ),
    );
  }

  /// Handles menu actions
  void _handleMenuAction(String action) {
    switch (action) {
      case "Share":
        print("Sharing ${widget.routeData.routeName}");
        break;
      case "Navigate":
        print("Navigating to ${widget.routeData.routeName}");
        break;
      case "Edit Details":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EditRoutePlannedScreen(routeData: widget.routeData),
          ),
        );
        break;
      case "Download for Offline":
        print("Downloading ${widget.routeData.routeName}");
        break;
      case "Delete from Library":
        print("Deleting ${widget.routeData.routeName}");
        break;
    }
  }
}
