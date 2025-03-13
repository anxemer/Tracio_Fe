import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/bloc/generic_data_cubit.dart';
import 'package:tracio_fe/domain/blog/entites/reaction_response_entity.dart';

import '../../../common/bloc/generic_data_state.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../domain/blog/usecase/get_reaction_blog.dart';
import '../../../service_locator.dart';

class ListReact extends StatefulWidget {
  const ListReact({super.key, required this.cubit, required this.blogId});
  final GenericDataCubit cubit;
  final int blogId;
  @override
  State<ListReact> createState() => _ListReactState();
}

class _ListReactState extends State<ListReact> {
  @override
  @override
  void initState() {
    super.initState();
    widget.cubit.getData<List<ReactionResponseEntity>>(
        sl<GetReactBlogUseCase>(),
        params: widget.blogId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericDataCubit, GenericDataState>(
      bloc: widget.cubit,
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DataLoaded) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r)),
            child: Container(
              color: Colors.white,
              height: 300.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 8.h,
                    left: 260.w,
                    child: Container(
                      width: 200.w,
                      height: 3.h,
                      color: Colors.black,
                    ),
                  ),
                  ListView.builder(
                    itemCount: state.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.h, vertical: 10.h),
                        child: _reactItem(state.data[index]),
                      );
                    },
                  ),
                  // Positioned(bottom: 0, right: 0, left: 0, child: _comment())
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _reactItem(ReactionResponseEntity reaction) {
    return Container(
      decoration: BoxDecoration(
          // color: AppColors.background.withValues(alpha: .2),
          borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: ClipOval(
          child: SizedBox(
            width: 40.w,
            height: 40.h,
            child: Image.asset(AppImages.man),
          ),
        ),
        title: Text(
          reaction.cyclistName!,
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
