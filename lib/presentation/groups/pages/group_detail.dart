import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/groups/models/request/get_group_list_req.dart';
import 'package:Tracio/domain/auth/entities/user.dart';
import 'package:Tracio/presentation/groups/cubit/group_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/group_state.dart';
import 'package:Tracio/presentation/groups/pages/group.dart';
import 'package:Tracio/presentation/groups/widgets/detail/group_detail_loaded.dart';
import 'package:Tracio/presentation/groups/widgets/detail/group_detail_skeleton.dart';

class GroupDetailScreen extends StatefulWidget {
  final int groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  UserEntity? loginUser;
  bool isJoined = false;
  bool isOrganizer = false;
  Future<void> _onRefresh() async {
    context.read<GroupCubit>().getGroupDetail(widget.groupId);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && Navigator.canPop(context)) {
          GetGroupListReq request =
              GetGroupListReq(pageNumber: 1, pageSize: 10, getMyGroups: true);
          context.read<GroupCubit>().getGroupList(request);
          AppNavigator.pushAndRemove(context, GroupPage());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: _buildAppBar(),
        body: BlocConsumer<GroupCubit, GroupState>(
          listener: (context, state) {
            if (state is GroupFailure) {
              _showFailureSnackBar(state.errorMessage);
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              displacement: 20,
              color: AppColors.primary,
              onRefresh: _onRefresh,
              child: _buildBody(state),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return BasicAppbar(
      hideBack: true,
      height: AppSize.appBarHeight.h,
      action: _buildActionIcons(),
    );
  }

  Widget _buildActionIcons() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            highlightColor: Colors.grey.shade600,
            splashColor: Colors.white.withAlpha(30),
            hoverColor: Colors.white.withAlpha(10),
            onPressed: () {
              GetGroupListReq request = GetGroupListReq(
                pageNumber: 1,
                pageSize: 10,
              );
              context.read<GroupCubit>().getGroupList(request);
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: AppSize.iconMedium.w,
            ),
            tooltip: "Go Back",
          ),
          Spacer(),
          IconButton(
            padding: EdgeInsets.zero,
            highlightColor: Colors.grey.shade600,
            splashColor: Colors.white.withAlpha(30),
            hoverColor: Colors.white.withAlpha(10),
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: Colors.white,
              size: AppSize.iconMedium.w,
            ),
            tooltip: "Settings",
          ),
        ],
      ),
    );
  }

  void _showFailureSnackBar(String errorMessage) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Something went wrong, please try later!\n$errorMessage'),
        ),
      );
    }
  }

  Widget _buildBody(GroupState state) {
    if (state is GroupLoading) {
      return GroupDetailSkeleton();
    }

    if (state is GetGroupDetailSuccess) {
      return GroupDetailLoaded();
    }

    return GroupDetailSkeleton();
  }
}
