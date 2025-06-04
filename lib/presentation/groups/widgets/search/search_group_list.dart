import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/domain/groups/entities/group.dart';
import 'package:Tracio/presentation/groups/cubit/group_cubit.dart';
import 'package:Tracio/presentation/groups/widgets/search/search_group_item.dart';
import 'package:Tracio/data/groups/models/request/get_group_list_req.dart';

class SearchGroupList extends StatelessWidget {
  final List<Group> groups;
  final bool hasNextPage;
  final int currentPage;
  final int pageSize;
  final String? searchName;
  final String? location;

  const SearchGroupList({
    super.key,
    required this.groups,
    required this.hasNextPage,
    required this.currentPage,
    required this.pageSize,
    this.searchName,
    this.location,
  });

  void _loadNextPage(BuildContext context) {
    if (hasNextPage) {
      context.read<GroupCubit>().getGroupList(
            GetGroupListReq(
              pageNumber: currentPage + 1,
              pageSize: pageSize,
              getMyGroups: false,
              searchName: searchName,
              location: location,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification &&
            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.8) {
          _loadNextPage(context);
        }
        return true;
      },
      child: ListView.builder(
        itemCount: groups.length + (hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == groups.length) {
            // Show loading indicator at the end if there are more pages
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SearchGroupItem(group: groups[index]);
        },
      ),
    );
  }
}
