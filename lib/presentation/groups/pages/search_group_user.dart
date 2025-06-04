import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/data/groups/models/request/get_group_list_req.dart';
import 'package:Tracio/presentation/groups/cubit/group_cubit.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Tracio/domain/groups/entities/group.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/presentation/groups/widgets/search/search_users_tab.dart';
import 'package:Tracio/presentation/groups/widgets/search/search_group_tab.dart';

class SearchGroupUser extends StatefulWidget {
  const SearchGroupUser({super.key});

  @override
  State<SearchGroupUser> createState() => _SearchGroupUserState();
}

class _SearchGroupUserState extends State<SearchGroupUser>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Users'),
            Tab(text: 'Groups'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocProvider.value(
            value: context.read<GroupCubit>(),
            child: SearchUsersTab(),
          ),
          BlocProvider.value(
            value: context.read<GroupCubit>()
              ..getGroupList(GetGroupListReq(
                  pageNumber: 1, pageSize: 10, getMyGroups: false)),
            child: SearchGroupTab(),
          ),
        ],
      ),
    ));
  }
}

class SearchGroupList extends StatelessWidget {
  final List<Group> groups;

  const SearchGroupList({
    super.key,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return SearchGroupItem(group: groups[index]);
      },
    );
  }
}

class SearchGroupItem extends StatelessWidget {
  final Group group;

  const SearchGroupItem({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Group Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: group.groupThumbnail,
              width: 60.w,
              height: 60.w,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Group Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.groupName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${group.participantCount} participants',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Join Button
          TextButton(
            onPressed: () {
              // Implement join group logic
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              'Join',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchUserList extends StatelessWidget {
  final List<dynamic> users;

  const SearchUserList({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserListItem(
          name: user.name,
          avatarUrl: user.avatarUrl,
          isFollowing: user.isFollowing,
        );
      },
    );
  }
}
