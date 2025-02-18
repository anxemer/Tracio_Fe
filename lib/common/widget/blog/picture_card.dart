import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/configs/theme/assets/app_images.dart';

class PictureCard extends StatefulWidget {
  const PictureCard({super.key, required this.listImageUrl});
  final List<String> listImageUrl;
  @override
  State<PictureCard> createState() => _PictureCardState();
}

class _PictureCardState extends State<PictureCard> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 600.h,
          width: 750.w,
          child: Stack(
            children: [
              PageView.builder(
                onPageChanged: (value) => setState(() {
                  _currentPage = value;
                }),
                controller: _pageController,
                itemCount: widget.listImageUrl.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(widget.listImageUrl[index],
                      fit: BoxFit.cover);
                },
              ),
              if (widget.listImageUrl.length >
                  1) // Hiển thị số trang nếu có nhiều ảnh
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        List.generate(widget.listImageUrl.length, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 32.w : 16.w,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
