import 'package:flutter/material.dart';

class CustomModalBottomSheet {
  /// Shows a modal bottom sheet with customizable properties
  ///
  /// Parameters:
  /// - context: BuildContext for showing the modal
  /// - child: Widget to display inside the modal
  /// - initialSize: Initial size of the modal (default: 0.8)
  /// - maxSize: Maximum size the modal can expand to (default: 0.8)
  /// - minSize: Minimum size the modal can shrink to (default: 0.2)
  /// - isDismissible: Whether modal can be dismissed by tapping outside (default: true)
  /// - isScrollControlled: Whether modal adapts to its content (default: true)
  /// - backgroundColor: Background color of the sheet (default: transparent)
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double initialSize = 0.8,
    double maxSize = 0.8,
    double minSize = 0.2,
    bool isDismissible = true,
    bool isScrollControlled = true,
    Color backgroundColor = Colors.transparent,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            maxChildSize: maxSize,
            initialChildSize: initialSize,
            minChildSize: minSize,
            builder: (context, scrollController) => child,
          ),
        );
      },
    );
  }
}
