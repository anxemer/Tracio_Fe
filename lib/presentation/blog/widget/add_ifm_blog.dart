import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/presentation/blog/bloc/category/get_category_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/category/select_category_cubit.dart';

import '../bloc/category/get_category_state.dart';

class AddIfmBlog extends StatefulWidget {
  const AddIfmBlog({super.key});

  @override
  State<AddIfmBlog> createState() => _AddIfmBlogState();
}

class _AddIfmBlogState extends State<AddIfmBlog> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCategoryCubit, GetCategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return Center(child: const CircularProgressIndicator());
        }
        if (state is CategoryLoaded) {
          return ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  context.read<SelectCategoryCubit>().selectCate(index);
                  setState(() {
                    index = context.read<SelectCategoryCubit>().selectedIndex;
                  });
                },
                child: Container(
                  width: 200.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: context.read<SelectCategoryCubit>().selectedIndex ==
                            index
                        ? AppColors.secondBackground
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      state.categories[index].categoryName.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20.sp),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: 14,
            ),
            itemCount: state.categories.length,
          );
        }
        return Container();
      },
    );
  }
}
