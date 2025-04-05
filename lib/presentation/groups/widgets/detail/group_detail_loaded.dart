import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_state.dart';
import 'package:tracio_fe/presentation/groups/pages/create_group_activity.dart';
import 'package:tracio_fe/presentation/groups/widgets/detail/empty_group_activity.dart';

class GroupDetailLoaded extends StatefulWidget {
  const GroupDetailLoaded({
    super.key,
  });

  @override
  State<GroupDetailLoaded> createState() => _GroupDetailLoadedState();
}

class _GroupDetailLoadedState extends State<GroupDetailLoaded> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        if (state is GetGroupDetailSuccess) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(AppSize.apHorizontalPadding),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Avatar
                  Container(
                    width: 100.w,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        state.group.groupThumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, url, error) => Container(
                          width: AppSize.imageSmall.w,
                          height: AppSize.imageSmall.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.error,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.apHorizontalPadding / 2,
                  ),
                  //Group name

                  Text(
                    state.group.groupName,
                    style: TextStyle(
                        fontSize: AppSize.textHeading.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: AppSize.apHorizontalPadding / 2,
                  ),
                  //Address
                  Text(
                    "Group location: ${state.group.district}, ${state.group.city}",
                    style: TextStyle(
                        fontSize: AppSize.textMedium.sp, color: Colors.black54),
                  ),
                  const SizedBox(
                    height: AppSize.apHorizontalPadding,
                  ),
                  Wrap(
                    spacing: AppSize.apHorizontalPadding / 2,
                    runSpacing: AppSize.apHorizontalPadding / 2,
                    children: [
                      SizedBox(
                        width: 120.w,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.people_outline,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 8.0),
                            Text("data"),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 120.w,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 8.0),
                            Text("data"),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSize.apHorizontalPadding),
                      SizedBox(
                        width: 120.w,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.pedal_bike_outlined,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 8.0),
                            Text("data"),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSize.apHorizontalPadding),
                  //Description
                  if (state.group.description != null &&
                      state.group.description!.isNotEmpty)
                    Text(
                      state.group.description!,
                      style: TextStyle(
                          fontSize: AppSize.textMedium.sp,
                          color: Colors.black87),
                    ),
                  SizedBox(
                      height: state.group.description != null &&
                              state.group.description!.isNotEmpty
                          ? AppSize.apSectionMargin
                          : 0),
                  const Divider(),
                  const SizedBox(height: AppSize.apHorizontalPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipOval(
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Edit')
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipOval(
                              child: IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Overview')
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipOval(
                              child: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Activities')
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSize.apHorizontalPadding),
                  const Divider(),

                  const SizedBox(height: AppSize.apSectionMargin),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "No upcoming activities",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppNavigator.push(context, CreateGroupActivity());
                        },
                        child: Text(
                          "Create an event",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSize.apHorizontalPadding / 2),

                  EmptyGroupActivity()
                ],
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
