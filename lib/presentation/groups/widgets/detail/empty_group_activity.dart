import 'package:flutter/material.dart';
import 'package:Tracio/core/constants/app_size.dart';

class EmptyGroupActivity extends StatelessWidget {
  const EmptyGroupActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.apHorizontalPadding),
      width: MediaQuery.of(context).size.width,
      // height: 120.h,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 2.0,
                offset: Offset(1, 2),
                color: Colors.grey.shade300,
                spreadRadius: 1)
          ],
          borderRadius: BorderRadius.circular(12.0)),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 80,
            child: Column(
              children: [
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0))),
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0))),
                ))
              ],
            ),
          ),
          SizedBox(
            width: AppSize.apHorizontalPadding,
          ),
          Expanded(
            child: Wrap(
              spacing: AppSize.apHorizontalPadding / 3,
              runSpacing: AppSize.apHorizontalPadding / 3,
              children: [
                _buildSkeleton(200, 10),
                _buildSkeleton(50, 10),
                _buildSkeleton(30, 10),
                _buildSkeleton(20, 10),
                _buildSkeleton(60, 10),
                _buildSkeleton(30, 10),
                _buildSkeleton(30, 10),
                _buildSkeleton(20, 10),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildSkeleton(double width, double height,
      {double borderRadius = 12}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
      ),
    );
  }
}
