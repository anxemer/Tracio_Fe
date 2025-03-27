import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/blog/bloc/category/get_category_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/category/get_category_state.dart';

import '../../../common/bloc/button/input_form_button.dart';
import '../../../common/bloc/filter_cubit.dart';
import '../../../common/filter_params.dart';
import '../../../common/inpit_range_slider.dart';
import 'category_service.dart';

class FilterView extends StatelessWidget {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetCategoryCubit()..getCategoryService(),
        ),
        BlocProvider(
          create: (context) => FilterCubit(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Filter"),
          actions: [
            IconButton(
              onPressed: () {
                // context.read<FilterCubit>().reset();
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: ListView(
          children: [
            // BlocBuilder<GetCategoryCubit, GetCategoryState>(
            //   builder: (context, categoryState) {
            //     if (categoryState is CategoryLoaded) {
            //       return ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         shrinkWrap: true,
            //         physics: BouncingScrollPhysics(),
            //         itemCount: categoryState.categories.length,
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 20,
            //           vertical: 10,
            //         ),
            //         itemBuilder: (context, index) => Row(
            //           children: [
            //             CategoryService(
            //               cateService: categoryState.categories,
            //             ),
            //             const Spacer(),
            //             BlocBuilder<FilterCubit, FilterParams>(
            //               builder: (context, filterState) {
            //                 return Checkbox(
            //                   value: filterState.categories.contains(
            //                           categoryState.categories[index]) ||
            //                       filterState.categories.isEmpty,
            //                   onChanged: (bool? value) {
            //                     context.read<FilterCubit>().updateCategory(
            //                         category: categoryState.categories[index]);
            //                   },
            //                 );
            //               },
            //             )
            //           ],
            //         ),
            //       );
            //     }
            //     return Container();
            //   },
            // ),

            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "Price Range",
                style: TextStyle(
                  fontSize: AppSize.textLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocBuilder<FilterCubit, FilterParams>(
              builder: (context, state) {
                return RangeSliderExample(
                  initMin: state.minPrice,
                  initMax: state.maxPrice,
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Builder(builder: (context) {
              return InputFormButton(
                color: Colors.black87,
                onClick: () {
                  // context
                  //     .read<getBloc>()
                  //     .add(GetProducts(context
                  //     .read<FilterCubit>()
                  //     .state));
                  // Navigator.of(context).pop();
                },
                titleText: 'Continue',
              );
            }),
          ),
        ),
      ),
    );
  }
}
