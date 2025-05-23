import 'package:flutter/material.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';

class RangeSliderExample extends StatefulWidget {
  final double initMin;
  final double initMax;
  final double max;
  final Function(double start, double end) onChanged;
  const RangeSliderExample({
    super.key,
    required this.initMin,
    required this.initMax,
    required this.onChanged,
    required this.max,
  });

  @override
  State<RangeSliderExample> createState() => _RangeSliderExampleState();
}

class _RangeSliderExampleState extends State<RangeSliderExample> {
  // final double max = 1000;
  // final double min = 0;
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    _currentRangeValues = RangeValues(widget.initMin, widget.initMax);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RangeSliderExample oldWidget) {
    _currentRangeValues = RangeValues(widget.initMin, widget.initMax);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.apVerticalPadding,
        ),
        child: Align(
          alignment: Alignment.center,
          child: RangeSlider(
            values: _currentRangeValues,
            max: widget.max,
            divisions: 10,
            activeColor: AppColors.secondBackground,
            labels: RangeLabels(
              _currentRangeValues.start.round().toString(),
              _currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              if (values.start < values.end) {
                setState(() {
                  _currentRangeValues = values;
                });

                widget.onChanged(values.start, values.end);
              }
            },
          ),
        ),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: Text(
          _currentRangeValues.start.round().toString(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Text(
          _currentRangeValues.end.round().toString(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }
}
