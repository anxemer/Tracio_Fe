import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/blog/bloc/category/get_category_cubit.dart';
import 'package:Tracio/presentation/blog/bloc/category/select_category_cubit.dart';

import '../bloc/category/get_category_state.dart';

class AddCategoryBlog extends StatefulWidget {
  const AddCategoryBlog({super.key});

  @override
  State<AddCategoryBlog> createState() => _AddCategoryBlogState();
}

class _AddCategoryBlogState extends State<AddCategoryBlog> {
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
                  width: 120.w,
                  height: 10.h,
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
                          fontWeight: FontWeight.w500,
                          fontSize: AppSize.textMedium.sp),
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
