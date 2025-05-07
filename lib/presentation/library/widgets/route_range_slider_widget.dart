import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/library/bloc/route_filter_cubit.dart';
import 'package:Tracio/presentation/library/bloc/route_filter_state.dart';

class RouteRangeSliderWidget extends StatefulWidget {
  final String filterType;

  const RouteRangeSliderWidget({super.key, required this.filterType});

  @override
  State<RouteRangeSliderWidget> createState() => _RouteRangeSliderWidgetState();
}

class _RouteRangeSliderWidgetState extends State<RouteRangeSliderWidget> {
  late int start, end, maxEnd;
  late String unit, title;

  @override
  void initState() {
    super.initState();
    final state = context.read<RouteFilterCubit>().state;

    switch (widget.filterType) {
      case "length":
        start = state.lengthStart;
        end = state.lengthEnd;
        maxEnd = state.maxLength;
        title = "Length";
        unit = "km";
        break;
      case "elevation":
        start = state.elevationStart;
        end = state.elevationEnd;
        maxEnd = state.maxElevation;
        title = "Elevation";
        unit = "ft";
        break;
      case "moving_time":
        start = state.movingTimeStart;
        end = state.movingTimeEnd;
        maxEnd = state.maxMovingTime;
        title = "Moving Time";
        unit = "hrs";
        break;
      case "speed":
        start = state.speedStart;
        end = state.speedEnd;
        maxEnd = state.maxSpeed;
        title = "Speed";
        unit = "km/h";
        break;
      default:
        title = "Unknown";
        start = 0;
        end = 0;
        maxEnd = 0;
        unit = "any";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteFilterCubit, RouteFilterState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSize.apHorizontalPadding,
            AppSize.apVerticalPadding / 2,
            AppSize.apHorizontalPadding,
            AppSize.apVerticalPadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(10))),
                  onPressed: () {
                    context
                        .read<RouteFilterCubit>()
                        .resetFilter(widget.filterType);
                    setState(() {
                      start = 0;
                      end = maxEnd;
                    });
                  },
                  child: const Text("Reset",
                      style: TextStyle(
                        color: AppColors.primary,
                      )),
                ),
                Text(title,
                    style: const TextStyle(
                      fontSize: AppSize.textMedium,
                      fontWeight: FontWeight.w500,
                    )),
                TextButton(
                  onPressed: () {
                    context.read<RouteFilterCubit>().setRange(
                          type: widget.filterType,
                          start: start,
                          end: end,
                        );
                    Navigator.pop(context);
                  },
                  child:
                      const Text("Save", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            Text("$start - $end${end == maxEnd ? "+" : ""} $unit"),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: Colors.white,
                activeTrackColor: AppColors.secondBackground,
                inactiveTrackColor: Colors.grey.shade300,
                overlayColor: Colors.white.withAlpha(2),
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 20),
              ),
              child: RangeSlider(
                values: RangeValues(start.toDouble(), end.toDouble()),
                min: 0,
                divisions: maxEnd,
                max: maxEnd.toDouble(),
                labels: RangeLabels("${start.toInt()}", "${end.toInt()}"),
                onChanged: (values) {
                  setState(() {
                    start = values.start.toInt();
                    end = values.end.toInt();
                  });
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
