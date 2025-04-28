import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/groups/models/request/get_group_list_req.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_state.dart';
import 'package:tracio_fe/presentation/groups/cubit/invitation_bloc.dart';
import 'package:tracio_fe/presentation/groups/pages/create_group.dart';
import 'package:tracio_fe/presentation/groups/widgets/my_group_item.dart';
import 'package:tracio_fe/presentation/groups/widgets/recommend_group_item.dart';

class GroupTab extends StatefulWidget {
  const GroupTab({super.key});

  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (context.read<GroupCubit>().state is! GetGroupListSuccess) {
      _onRefresh();
    }
  }

  void _onRefresh() async {
    GetGroupListReq request =
        GetGroupListReq(pageNumber: 1, pageSize: 5, getMyGroups: true);
    context.read<GroupCubit>().getGroupList(request);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      displacement: 20,
      color: AppColors.primary,
      onRefresh: () async {
        _onRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Create your group
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: AppSize.apHorizontalPadding,
                  vertical: AppSize.apVerticalPadding / 2),
              child: Row(
                children: [
                  Text("Create your own Group"),
                  Spacer(),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                      side: WidgetStatePropertyAll(
                          BorderSide(color: AppColors.primary, width: 1)),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<InvitationBloc>(
                                        context),
                                    child: CreateGroupScreen(),
                                  )));
                    },
                    child: Text(
                      "Create a group",
                      style: TextStyle(
                          fontSize: AppSize.textSmall.sp,
                          color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            // List my group
            BlocConsumer<GroupCubit, GroupState>(
              listener: (context, state) {
                if (state is GroupFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Something went wrong, please try later!\n${state.errorMessage}'),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is GetGroupListSuccess && state.hasMyGroups) {
                  if (state.groupList.isEmpty) {
                    return Center(child: Text("No groups found"));
                  } else {
                    return ListView.builder(
                      itemCount: state.groupList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MyGroupItem(
                          group: state.groupList[index],
                        );
                      },
                    );
                  }
                } else {
                  return SizedBox.shrink();
                }
              },
            ),

            // Groups near you
            BlocBuilder<GroupCubit, GroupState>(builder: (context, state) {
              if (state is GetGroupListSuccess && !state.hasMyGroups) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.apHorizontalPadding,
                      vertical: AppSize.apSectionPadding),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: AppSize.apHorizontalPadding / 2,
                      children: [
                        Icon(
                          Icons.local_attraction_rounded,
                          size: AppSize.iconMedium,
                        ),
                        Text("Popular Public Groups Near You",
                            style: TextStyle(
                                fontSize: AppSize.textSmall.sp,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ]),
                );
              } else {
                return SizedBox.shrink();
              }
            }),

            // List of recommended groups
            BlocConsumer<GroupCubit, GroupState>(
              listener: (context, state) {
                if (state is GroupFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Something went wrong, please try later!\n${state.errorMessage}'),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is GetGroupListSuccess && !state.hasMyGroups) {
                  if (state.groupList.isEmpty) {
                    return Center(child: Text("No groups found"));
                  } else {
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSize.apHorizontalPadding / 4),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSize.apHorizontalPadding / 4,
                        mainAxisSpacing: AppSize.apHorizontalPadding / 4,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: state.groupList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return RecommendGroupItem(
                          group: state.groupList[index],
                          membership: state.groupList[index].membership,
                        );
                      },
                    );
                  }
                } else {
                  return SizedBox.shrink();
                }
              },
            ),

            const SizedBox(
              height: AppSize.apVerticalPadding,
            ),
          ],
        ),
      ),
    );
  }
}
