import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Tracio/common/widget/drag_handle/drag_handle.dart';
import 'package:Tracio/core/constants/app_size.dart';

class RouteDetailSkeletonWidget extends StatelessWidget {
  const RouteDetailSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: DragHandle(width: 80, height: 6),
          ),
          const SizedBox(
            height: AppSize.apVerticalPadding,
          ),
          Row(
            children: [
              _buildSkeleton(50, 50, borderRadius: 50),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                  child: Column(
                children: [
                  _buildSkeleton(double.infinity, 20.w),
                  const SizedBox(
                    height: 4.0,
                  ),
                  _buildSkeleton(double.infinity, 15.w),
                ],
              ))
            ],
          ),
          SizedBox(
            height: AppSize.apSectionMargin * 2.h,
          ),
          _buildSkeleton(double.infinity, 30.w),
          const SizedBox(
            height: 8.0,
          ),
          _buildSkeleton(double.infinity, 20.w),
          const SizedBox(
            height: AppSize.apSectionMargin,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildSkeleton(80.w, 15.w),
                    SizedBox(height: 4.h),
                    _buildSkeleton(120.w, 25.w),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: AppSize.apSectionMargin,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSize.apHorizontalPadding),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.shade200)),
            child: Column(
              children: [
                _buildSkeleton(double.infinity, 20.w),
                SizedBox(height: 12.h),
                _buildSkeleton(double.infinity, 15.w),
                SizedBox(height: 24.h),
                _buildSkeleton(double.infinity, 30.w),
              ],
            ),
          ),
          const SizedBox(
            height: AppSize.apSectionMargin,
          ),
          Row(
            children: [
              _buildSkeleton(40.w, 40.w, borderRadius: 5),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(child: _buildSkeleton(double.infinity, 20.w)),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildSkeleton(40.w, 40.w, borderRadius: 5),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(child: _buildSkeleton(double.infinity, 20.w)),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildSkeleton(40.w, 40.w, borderRadius: 5),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(child: _buildSkeleton(double.infinity, 20.w)),
            ],
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Shimmer _buildSkeleton(double width, double height,
      {double borderRadius = 12}) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius:
                BorderRadius.circular(borderRadius), // Rounded corners
          ),
        ));
  }
}
