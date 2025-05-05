// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';

import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/common/widget/button/button.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/blog/models/request/create_blog_req.dart';
import 'package:tracio_fe/presentation/blog/bloc/category/get_category_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/category/select_category_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/create_blog_cubit.dart';
import 'package:tracio_fe/presentation/blog/widget/add_category_blog.dart';
import 'package:tracio_fe/presentation/blog/widget/choose_audience_blog.dart';
import 'package:tracio_fe/presentation/home/pages/home.dart';

import '../../../common/widget/navbar/bottom_nav_bar_manager.dart';
import '../bloc/create_blog_state.dart';

class AddTitleBlogPage extends StatefulWidget {
  AddTitleBlogPage({
    Key? key,
    required this.file,
  }) : super(key: key);
  final List<File> file;

  @override
  State<AddTitleBlogPage> createState() => _AddTitleBlogPageState();
}

class _AddTitleBlogPageState extends State<AddTitleBlogPage> {
  int category = 0;
  late CreateBlogReq create;
  late PageController _pageController;
  int _currentPage = 0;
  int audience = 0;
  TextEditingController _titleCon = TextEditingController();
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CreateBlogCubit(),
        ),
        BlocProvider(
          create: (context) => GetCategoryCubit()..getCategoryBlog(),
        ),
      ],
      child: BlocListener<CreateBlogCubit, CreateBlogState>(
        listener: (context, state) {
          if (state is CreateBlogSuccess) {
            AppNavigator.pushReplacement(context, HomePage());
          }
        },
        child: Scaffold(
          appBar: BasicAppbar(
            height: 60.h,
            centralTitle: true,
            title: Text(
              'New Post',
              style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 40.sp),
            ),
          ),
          body: BlocBuilder<CreateBlogCubit, CreateBlogState>(
            builder: (context, state) {
              print("Current state: $state");
              if (state is CreateBlogFail) {
                Text(state.error, style: TextStyle(color: Colors.red));
              }
              if (state is CreateBlogSuccess) {
                Future.microtask(() {
                  AppNavigator.pushAndRemove(context, BottomNavBarManager());
                });
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.file.length != 0
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: PageView.builder(
                                  onPageChanged: (value) => setState(() {
                                        _currentPage = value;
                                      }),
                                  controller: _pageController,
                                  itemCount: widget.file.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              AppSize.apHorizontalPadding.h),
                                      child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Image.file(
                                              widget.file[index],
                                              width: 400.w,
                                              // height: 300.h,
                                              fit: BoxFit.fill,
                                            ),
                                            Positioned(
                                              bottom: 10,
                                              left: 0,
                                              right: 0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: List.generate(
                                                    widget.file.length,
                                                    (index) {
                                                  return Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4),
                                                    width: _currentPage == index
                                                        ? 32.w
                                                        : 16.w,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      color: _currentPage ==
                                                              index
                                                          ? AppColors
                                                              .secondBackground
                                                          : const Color
                                                              .fromARGB(255,
                                                              255, 255, 255),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            )
                                          ]),
                                    );
                                  }),
                            )
                          : Container(),
                      Divider(),
                      SizedBox(
                          height: 50.h,
                          width: double.infinity,
                          child: TextField(
                            controller: _titleCon,
                            decoration:
                                InputDecoration(hintText: 'Add title.....'),
                          )),
                      Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Category',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSize.textLarge.sp),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                              height: 40.h,
                              child: BlocProvider(
                                create: (context) => SelectCategoryCubit(),
                                child: BlocBuilder<SelectCategoryCubit, int>(
                                  builder: (context, intdex) {
                                    category = intdex + 1;

                                    return AddCategoryBlog();
                                  },
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        height: 10.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      GestureDetector(
                        onTap: () async {
                          int result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChooseAudienceBlog(
                                  selectedIndex: audience,
                                ),
                              ));
                          if (result != null) {
                            setState(() {
                              audience =
                                  result; // Cập nhật audience với kết quả trả về
                            });
                          }
                        },
                        child: SizedBox(
                          height: 50.h,
                          child: Row(
                            children: [
                              Image.asset(
                                AppImages.eye,
                                width: 30,
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Text(
                                'Audience',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                              _textAudience(audience),
                              Icon(
                                Icons.navigate_next_outlined,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        height: 10.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      _button(context)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _button(BuildContext context) {
    return BlocBuilder<CreateBlogCubit, CreateBlogState>(
      builder: (context, state) {
        if (state is CreateBlogLoading) {
          return Center(child: const CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonDesign(
                height: 40.h,
                width: 140.w,
                ontap: () {
                  print(widget.file);
                  context.read<CreateBlogCubit>().CreateBlog(CreateBlogReq(
                      categoryId: category,
                      content: _titleCon.text,
                      isPublic: audience == 0,
                      status: 0,
                      mediaFiles: widget.file));
                },
                text: 'Save',
                image: AppImages.draft,
                fillColor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.black,
                iconSize: AppSize.iconSmall,
                fontSize: AppSize.textMedium,
              ),
              ButtonDesign(
                height: 40.h,
                width: 140.w,
                ontap: () {
                  print(category);
                  context.read<CreateBlogCubit>().CreateBlog(CreateBlogReq(
                      categoryId: category,
                      content: _titleCon.text,
                      isPublic: audience == 1,
                      status: 1,
                      mediaFiles: widget.file));
                },
                text: 'Share',
                image: AppImages.share,
                fillColor: AppColors.secondBackground,
                textColor: Colors.white,
                borderColor: Colors.black,
                iconSize: AppSize.iconSmall,
                fontSize: AppSize.textMedium,
              )
            ],
          ),
        );
      },
    );
  }

  Widget _textAudience(int index) {
    if (index == 0) {
      return Text(
        'Private',
        style: TextStyle(color: Colors.grey.shade500),
      );
    } else {
      return Text(
        'Public',
        style: TextStyle(color: Colors.grey.shade500),
      );
    }
    // return Text(
    //   'Follower Only',
    //   style: TextStyle(color: Colors.grey.shade500),
    // );
  }
}
