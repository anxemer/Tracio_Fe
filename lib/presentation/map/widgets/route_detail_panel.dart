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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: DragHandle(
                width: 100,
                height: 6,
              )),
        ]));
  }
}
