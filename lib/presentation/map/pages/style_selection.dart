import 'package:flutter/material.dart';

class StyleSelectionPage extends StatefulWidget {
  const StyleSelectionPage({super.key});

  @override
  State<StyleSelectionPage> createState() => _StyleSelectionPageState();
}

class _StyleSelectionPageState extends State<StyleSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Map Style'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Streets'),
            onTap: () {
              Navigator.pop(context, 'mapbox://styles/mapbox/streets-v12');
            },
          ),
          ListTile(
            title: const Text('Outdoors'),
            onTap: () {
              Navigator.pop(context, 'mapbox://styles/mapbox/outdoors-v12');
            },
          ),
          ListTile(
            title: const Text('Light'),
            onTap: () {
              Navigator.pop(context, 'mapbox://styles/mapbox/light-v11');
            },
          ),
          // Add more styles as needed
        ],
      ),
    );
  }
}
