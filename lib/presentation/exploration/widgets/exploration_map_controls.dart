import 'package:flutter/material.dart';

class ExplorationMapControls extends StatelessWidget {
  final VoidCallback onMapStyleChange;
  final VoidCallback onCenterLocation;

  const ExplorationMapControls({
    super.key,
    required this.onMapStyleChange,
    required this.onCenterLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      bottom: 16,
      child: Column(
        children: [
          FloatingActionButton.small(
            onPressed: onMapStyleChange,
            child: const Icon(Icons.layers),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            onPressed: onCenterLocation,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
} 