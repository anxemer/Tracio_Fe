import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tracio_fe/presentation/map/pages/style_selection.dart';
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
  final double _initTopBarTopPosition = 10.0;
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
            //Bottom: Sliding panel
            SlidingUpPanel(
              maxHeight: _panelHeightOpen,
              minHeight: _panelHeightClosed,
              parallaxEnabled: true,
              parallaxOffset: .5,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              onPanelSlide: (double pos) => setState(() {
                _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                    _initFabHeight;
              }),
              panelBuilder: (sc) => RouteDetailPanel(scrollController: sc),
              body: Stack(children: [
                MapView(),
              ]),
            ),
            
            //Right: Undo Redo buttons
            Positioned(
              bottom: _fabHeight,
              right: 10,
              child: Container(
                width: 40,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(100), bottom: Radius.circular(100)),
                ),
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.undo,
                        size: 20,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.redo,
                        size: 20,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            //TODO: Popup menu
            //Left: Configure buttons
            Positioned(
              bottom: _fabHeight,
              left: 10,
              child: Column(
                spacing: 10,
                children: [
                  //Center camera button
                  IconButton(
                    style: IconButton.styleFrom(
                      elevation: 2,
                      backgroundColor: Colors.white,
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      Icons.location_searching_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () {},
                  ),

                  //Change style button
                  IconButton(
                    style: IconButton.styleFrom(
                      elevation: 2,
                      backgroundColor: Colors.white,
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      Icons.layers,
                      color: Colors.black87,
                    ),
                    onPressed: () async {
                      // Navigate to the style selection page and await the result
                      final selectedStyle = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StyleSelectionPage()),
                      );

                      // Handle the selected style
                      if (selectedStyle != null) {
                        // Update the map style using the selectedStyle
                        print(
                            'Selected style: $selectedStyle'); // Replace with your logic
                      }
                    },
                  ),

                  //Change Cycling button
                  IconButton(
                    style: IconButton.styleFrom(
                      elevation: 2,
                      backgroundColor: Colors.white,
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      Icons.directions_bike_sharp,
                      color: Colors.black87,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            //Top: action bar
            Positioned(
              top: _initTopBarTopPosition,
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
