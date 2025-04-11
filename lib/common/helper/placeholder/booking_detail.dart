import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BookingDetailPlaceholder extends StatelessWidget {
  const BookingDetailPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
                baseColor: Colors.black26,
                highlightColor: Colors.black54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      width: 160,
                      height: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black26,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(3, (index) {
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
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [120, 180].asMap().entries.map((e) {
                            return Container(
                              width: e.value.toDouble(),
                              height: 12,
                              margin: EdgeInsets.only(top: e.key == 0 ? 0 : 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.black26,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
  }
}