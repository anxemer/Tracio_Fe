import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CyclingMetricCarousel extends StatelessWidget {
  final double odometerKm;
  final double speed;
  final double altitude;

  const CyclingMetricCarousel({
    super.key,
    required this.odometerKm,
    required this.speed,
    required this.altitude,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 100.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 0,
      ),
      items: [
        _buildMetricTile("Distance", "${odometerKm.toStringAsFixed(1)} km"),
        _buildMetricTile("Speed", "${speed.toStringAsFixed(1)} km/h"),
        _buildMetricTile("Elevation", "${altitude.toStringAsFixed(1)} m"),
      ],
    );
  }

  Widget _buildMetricTile(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
