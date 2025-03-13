import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

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
    return widget.listImageUrl.length != 0
        ? Column(
            children: [
              SizedBox(
                height: AppSize.imageExtraLarge.h,
                width: 750.w,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: AppSize.imageExtraLarge.h,
                          viewportFraction:
                              widget.listImageUrl.length == 1 ? 1 : 0.8,
                          enlargeCenterPage: true,
                          padEnds: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                        ),
                        items: widget.listImageUrl.map((imageUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(imageUrl,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, url, error) =>
                                            Icon(
                                              Icons.error,
                                              color: AppColors.background,
                                            ),
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }),
                                  ));
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            widget.listImageUrl.asMap().entries.map((entry) {
                          return Container(
                            width: _currentPage == entry.key ? 32.w : 16.w,
                            height: 8,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: _currentPage == entry.key
                                  ? AppColors.background
                                  : Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
