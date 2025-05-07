import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/library/widgets/graph/line_chart.dart';

class ElevationGraphWidget extends StatelessWidget {
  final List<double> elevationGains;
  final List<double> distances;
  const ElevationGraphWidget(
      {super.key, required this.elevationGains, required this.distances});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Elevation Gain",
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
              unitY: "m",
              dataX: distances,
              dataY: elevationGains,
              lineChartBarDataColor: Colors.grey.shade500,
            ),
          )),
        ],
      ),
    );
  }
}
