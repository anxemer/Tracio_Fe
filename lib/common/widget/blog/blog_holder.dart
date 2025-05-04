import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BlogHolder extends StatefulWidget {
  const BlogHolder({super.key});

  @override
  State<BlogHolder> createState() => _BlogHolderState();
}

class _BlogHolderState extends State<BlogHolder> {
  @override
  Widget build(BuildContext context) {
    return Center(
            child: Shimmer.fromColors(
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
           
            ],
          ),
    ));
  }
}