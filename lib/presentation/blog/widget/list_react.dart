import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/bloc/generic_data_cubit.dart';
import 'package:tracio_fe/common/widget/picture/circle_picture.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/blog/entites/reaction_response_entity.dart';

import '../../../common/bloc/generic_data_state.dart';
import '../../../common/widget/drag_handle/drag_handle.dart';
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
              // height: 300.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  DragHandle(
                    width: MediaQuery.of(context).size.width * 0.3.w,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Likes',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppSize.textHeading.sp,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.h, vertical: 10.h),
                          child: _reactItem(state.data[index]),
                        );
                      },
                    ),
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
              child: CirclePicture(
                  imageUrl: reaction.cyclistAvatar!,
                  imageSize: AppSize.iconMedium.sp)),
        ),
        title: Text(
          reaction.cyclistName!,
          style: TextStyle(
            fontSize: AppSize.textMedium.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
