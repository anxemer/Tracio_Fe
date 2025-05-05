import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../common/widget/picture/circle_picture.dart';
import '../../../core/constants/app_size.dart';
import '../../../domain/auth/entities/user.dart';
import '../../auth/bloc/authCubit/auth_cubit.dart';
import '../../auth/bloc/authCubit/auth_state.dart';
import '../../profile/pages/user_profile.dart';
import '../pages/create_blog.dart';

class CreateBlogHeader extends StatefulWidget {
  const CreateBlogHeader({super.key});
  @override
  State<CreateBlogHeader> createState() => _CreateBlogHeaderState();
}

class _CreateBlogHeaderState extends State<CreateBlogHeader> {
  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    UserEntity? user;

    if (state is AuthLoaded) {
      user = state.user;
    } else if (state is AuthChangeRole) {
      user = state.user;
    }
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 8.h, horizontal: AppSize.apHorizontalPadding.w),
      child: SizedBox(
          height: AppSize.appBarHeight.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () => AppNavigator.push(
                      context, UserProfilePage(userId: user!.userId)),
                  child: SizedBox(
                    child: CirclePicture(
                        imageUrl: user!.profilePicture!,
                        imageSize: AppSize.iconSmall.sp),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: InkWell(
                  onTap: () => AppNavigator.push(context, CreateBlogPage()),
                  child: Row(
                    children: [
                      Text(
                        'Share your picture',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: AppSize.textMedium.sp),
                      ),
                      Spacer(),
                      Icon(
                        Icons.image_outlined,
                        size: AppSize.iconLarge.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
