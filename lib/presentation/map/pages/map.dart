import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tracio_fe/presentation/map/widgets/map_view.dart';
import 'package:tracio_fe/presentation/map/widgets/route_detail_panel.dart';
import 'package:tracio_fe/presentation/map/widgets/top_action_bar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final double _initFabHeight = 160;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  final double _panelHeightClosed = 150.0;

  @override
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .33;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SlidingUpPanel(
              maxHeight: _panelHeightOpen,
              minHeight: _panelHeightClosed,
              parallaxEnabled: true,
              parallaxOffset: .5,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20), bottom: Radius.circular(20)),
              onPanelSlide: (double pos) => setState(() {
                _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                    _initFabHeight;
              }),
              panelBuilder: (sc) => RouteDetailPanel(scrollController: sc),
              body: Stack(children: [
                MapView(),
              ]),
            ),
            Positioned(
              bottom: _fabHeight,
              right: 10,
              child: FloatingActionButton(
                onPressed: () {
                  //_showStyleSelectionDialog
                },
                child: Icon(Icons.map),
              ),
            ),
            Positioned(
              top: 10,
              left: 20,
              right: 20,
              child: TopActionBar(),
            ),
          ],
        ),
      ),
    );
  }
}
