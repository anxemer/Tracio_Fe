import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CyclingMetricCarousel extends StatelessWidget {
  final double? odometerKm;
  final double? speed;
  final double? elevationGain;
  final Duration? duration;
  final double? avgSpeed;
  final double? batteryLevel;
  final double? altitude;
  final Duration? movingTime;

  const CyclingMetricCarousel({
    super.key,
    required this.odometerKm,
    required this.speed,
    required this.elevationGain,
    required this.duration,
    required this.avgSpeed,
    required this.batteryLevel,
    required this.altitude,
    required this.movingTime,
  });

  String _formatDuration(Duration? d) {
    if (d == null) return "--:--";
    return '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  String _formatDouble(double? value, {int fraction = 1, String unit = ""}) {
    return value != null ? "${value.toStringAsFixed(fraction)}$unit" : "--";
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 130,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
      ),
      items: [
        _buildFirstPage(),
        _buildSecondPage(),
      ],
    );
  }

  Widget _buildFirstPage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMetric("Distance", _formatDouble(odometerKm, unit: " km")),
            _buildMetric("Speed", _formatDouble(speed, unit: " km/h")),
            _buildMetric("Duration", _formatDuration(duration)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMetric("Elev. Gain",
                _formatDouble(elevationGain, fraction: 0, unit: " m")),
            _buildMetric("Avg Speed", _formatDouble(avgSpeed, unit: " km/h")),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondPage() {
    final now = DateFormat('HH:mm').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2.8,
        shrinkWrap: true,
        children: [
          _buildMetric(
              "Battery", _formatDouble(batteryLevel, fraction: 0, unit: "%")),
          _buildMetric("Time", now),
          _buildMetric("Elevation", _formatDouble(altitude, unit: " m")),
          _buildMetric("Moving", _formatDuration(movingTime)),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    final unitMatch = RegExp(r'([0-9\-.]+)(.*)').firstMatch(value);
    final numberPart = unitMatch?.group(1) ?? "--";
    final unitPart = unitMatch?.group(2) ?? "";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: numberPart,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: unitPart,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
