import 'package:flutter/material.dart';
import 'package:tracio_fe/common/widget/drag_handle/drag_handle.dart';

class RouteDetailPanel extends StatefulWidget {
  final ScrollController scrollController;

  const RouteDetailPanel({super.key, required this.scrollController});

  @override
  State<RouteDetailPanel> createState() => _RouteDetailPanelState();
}

class _RouteDetailPanelState extends State<RouteDetailPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: DragHandle(
                width: 100,
                height: 6,
              )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(width: 1.0, color: Colors.grey.shade600),
                left: BorderSide(width: 1.0, color: Colors.grey.shade600),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Route Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
        //Detail Panel
      ),
    );
  }
}
