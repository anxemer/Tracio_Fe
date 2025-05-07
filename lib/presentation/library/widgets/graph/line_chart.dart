import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Tracio/core/constants/app_size.dart';

class LineChartWidget extends StatefulWidget {
  final Color gridLineColor;
  final Color lineChartBarDataColor;
  final Color tooltipTextColor;
  final Color legendTextColor;
  final String unitY;
  final String unitX;
  final List<double> dataX;
  final List<double> dataY;

  const LineChartWidget(
      {super.key,
      required this.unitX,
      required this.unitY,
      required this.dataX,
      required this.dataY,
      this.gridLineColor = Colors.black26,
      this.lineChartBarDataColor = Colors.blue,
      this.tooltipTextColor = Colors.white,
      this.legendTextColor = Colors.grey});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<int> showingTooltipOnSpots = [];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: LineChart(
            mainData(),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: List.generate(widget.dataX.length,
            (i) => FlSpot(widget.dataX[i], widget.dataY[i])),
        isCurved: false,
        color: widget.lineChartBarDataColor,
        barWidth: 2,
        isStrokeCapRound: false,
        dotData: const FlDotData(show: false),
        belowBarData:
            BarAreaData(show: true, color: widget.lineChartBarDataColor),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];
    double maxX = _adjustToDivisibleBy4(widget.dataX.last, 4);
    double maxY = _adjustToDivisibleBy4(
      widget.dataY.reduce((a, b) => a > b ? a : b),
      4,
    );
    double minY = widget.dataY.reduce((a, b) => a < b ? a : b);

    if (maxX == 0) maxX = 1;
    if (maxY == 0) maxY = 1;

    double intervalX = (maxX / 4).abs();
    double intervalY = (maxY / 4).abs();

    return LineChartData(
      showingTooltipIndicators: showingTooltipOnSpots.map((index) {
        return ShowingTooltipIndicators([
          LineBarSpot(
            tooltipsOnBar,
            lineBarsData.indexOf(tooltipsOnBar),
            tooltipsOnBar.spots[index],
          ),
        ]);
      }).toList(),
      lineTouchData: LineTouchData(
        getTouchLineEnd: (data, index) => double.infinity,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: Colors.black,
                strokeWidth: 2,
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 2,
                    color: Colors.black,
                    strokeWidth: 1,
                    strokeColor: Colors.black,
                  );
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipMargin: 0,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          showOnTopOfTheChartBoxArea: true,
          getTooltipColor: (touchedSpot) => widget.lineChartBarDataColor,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              return LineTooltipItem(
                '${flSpot.x} ${widget.unitX} \n',
                TextStyle(
                    color: widget.tooltipTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.textLarge.sp),
                children: [
                  TextSpan(
                    text: '${flSpot.y.toString()} ${widget.unitY}',
                    style: TextStyle(
                        color: widget.tooltipTextColor,
                        fontSize: AppSize.textSmall.sp),
                  ),
                ],
                textAlign: TextAlign.left,
              );
            }).toList();
          },
        ),
        enabled: true,
        handleBuiltInTouches: false,
        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
          if (response == null || response.lineBarSpots == null) {
            return;
          }
          final spotIndex = response.lineBarSpots!.first.spotIndex;
          List<int> tmp = [spotIndex];
          setState(() {
            showingTooltipOnSpots = tmp;
          });
        },
      ),
      gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.black26, strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              FlLine(color: Colors.black26, strokeWidth: 1),
          verticalInterval: intervalX,
          horizontalInterval: intervalY),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(color: Colors.black26),
          top: BorderSide(color: Colors.black26),
          bottom: BorderSide(color: Colors.black, width: 2),
          right: BorderSide(color: Colors.black26),
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            maxIncluded: false,
            reservedSize: 24,
            interval: intervalX,
            getTitlesWidget: (value, meta) {
              if (value == 0) return Container();
              return Text(
                '${value.toInt()}km',
                style: TextStyle(
                    fontSize: AppSize.textSmall * 1.1.sp,
                    color: widget.legendTextColor),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            maxIncluded: false,
            showTitles: true,
            reservedSize: AppSize.textSmall * 1.1.sp + 20,
            interval: intervalY,
            getTitlesWidget: (value, meta) {
              if (value == 0) {
                return Text(
                  "km/h",
                  style: TextStyle(
                      fontSize: AppSize.textSmall * 1.1.sp,
                      color: widget.legendTextColor),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  '${value.toDouble()}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: AppSize.textSmall * 1.1.sp,
                      color: widget.legendTextColor),
                ),
              );
            },
          ),
        ),
      ),
      minX: 0,
      maxX: maxX,
      minY: minY > 0 ? 0 : minY,
      maxY: maxY + intervalY,
      lineBarsData: [tooltipsOnBar],
    );
  }

  double _adjustToDivisibleBy4(double value, int step) {
    double rounded = (value / step).ceil() * step.toDouble();
    while (rounded % 4 != 0) {
      rounded += step;
    }
    return rounded;
  }
}
