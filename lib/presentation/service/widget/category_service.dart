import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/shop/models/get_service_req.dart';
import 'package:tracio_fe/domain/blog/entites/category.dart';
import 'package:tracio_fe/presentation/service/bloc/service_bloc/get_service_cubit.dart';

class CategoryService extends StatefulWidget {
  const CategoryService({super.key, required this.cateService});
  final List<CategoryEntity> cateService;
  @override
  State<CategoryService> createState() => _CategoryServiceState();
}

class _CategoryServiceState extends State<CategoryService> {
  int selectIndex = 0;
  // final categories = [
  //   'All',
  //   'Repair',
  //   'Maintenance',
  //   'Customization',
  //   'Accessories'
  // ];
  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.cateService.length,
          (index) => Padding(
              padding: EdgeInsets.all(8),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                child: ChoiceChip(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  label: Text(
                    widget.cateService[index].categoryName!,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: selectIndex == index
                            ? AppSize.textLarge
                            : AppSize.textMedium,
                        color: isDark ? Colors.grey.shade200 : Colors.black87),
                  ),
                  selectedColor: context.isDarkMode
                      ? AppColors.primary
                      : AppColors.background,
                  selected: selectIndex == index,
                  pressElevation: 0,
                  backgroundColor: Colors.transparent,
                  elevation: selectIndex == index ? 2 : 0,
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide(
                      color: selectIndex == index
                          ? Colors.transparent
                          : isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300),
                  onSelected: (bool selected) {
                    setState(() {
                      selectIndex = index;
                    });
                    context
                        .read<GetServiceCubit>()
                        .getService(GetServiceReq(categoryId: selectIndex));
                  },
                ),
              )),
        ),
      ),
    );
  }
}
