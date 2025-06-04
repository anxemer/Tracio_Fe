import 'package:flutter/material.dart';
import 'package:Tracio/presentation/groups/widgets/search/search_user_item.dart';

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
        return SearchUserItem(
          name: user.name,
          avatarUrl: user.avatarUrl,
          isFollowing: user.isFollowing,
        );
      },
    );
  }
} 