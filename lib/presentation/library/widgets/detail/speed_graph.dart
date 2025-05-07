import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/library/widgets/graph/line_chart.dart';

class SpeedGraphWidget extends StatelessWidget {
  final List<double> speeds;
  final List<double> distances;
  const SpeedGraphWidget(
      {super.key, required this.distances, required this.speeds});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Speed",
            style: TextStyle(
                fontSize: AppSize.textLarge * 1.2.sp,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: AppSize.apVerticalPadding,
          ),
          Center(
              child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: LineChartWidget(
              unitX: "km",
              unitY: "km/h",
              dataX: distances,
              dataY: speeds,
            ),
          )),
        ],
      ),
    );
  }
}
