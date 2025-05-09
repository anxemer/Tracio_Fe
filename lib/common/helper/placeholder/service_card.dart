import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ServiceCardPlaceHolder extends StatefulWidget {
  const ServiceCardPlaceHolder({super.key});

  @override
  State<ServiceCardPlaceHolder> createState() => _ServiceCardPlaceHolderState();
}

class _ServiceCardPlaceHolderState extends State<ServiceCardPlaceHolder> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.black38,
          highlightColor: Colors.black87,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.black38,
            ),
          ),
        ),
        SizedBox(
          height: 6.h,
        ),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.black38,
            highlightColor: Colors.black54,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 160,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black26,
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Row(
                  children: [82, 24].asMap().entries.map((e) {
                    return Container(
                      width: e.value.toDouble(),
                      height: 24,
                      margin: EdgeInsets.only(left: e.key == 0 ? 0 : 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black26,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(2, (index) {
                    return Container(
                      width: double.infinity,
                      height: 12,
                      margin: EdgeInsets.only(top: index == 0 ? 0 : 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black26,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
