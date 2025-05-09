import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:flutter/material.dart';

class Follower {
  final String avatarUrl;
  final String username;
  final String fullName;
  final bool isFollowedBack;

  Follower({
    required this.avatarUrl,
    required this.username,
    required this.fullName,
    required this.isFollowedBack,
  });
}

class FollowersScreen extends StatelessWidget {
  final List<Follower> followers = [
    Follower(
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        username: 'thoi.khongbietvay.5',
        fullName: 'Việt Nguyễn',
        isFollowedBack: false),
    Follower(
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        username: 'tnguyendvan',
        fullName: 'Nguyễn Văn Thưởng',
        isFollowedBack: false),
    Follower(
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        username: 'lee_nhuw_',
        fullName: 'Lê Như',
        isFollowedBack: false),
    Follower(
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        username: 'mq.zer05',
        fullName: 'Nguyễn Minh Quý',
        isFollowedBack: true),
    // Thêm các follower khác nếu cần
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
      ),
      body: ListView.builder(
        itemCount: followers.length,
        itemBuilder: (context, index) {
          final follower = followers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(follower.avatarUrl),
            ),
            title: Text(follower.username,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(follower.fullName),
            trailing: follower.isFollowedBack
                ? _messageButton()
                : _followBackButton(),
          );
        },
      ),
    );
  }

  Widget _followBackButton() {
    return ElevatedButton(
      onPressed: () {
        // Xử lý follow back
      },
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: AppSize.textLarge),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      child: Text('Follow back'),
    );
  }

  Widget _messageButton() {
    return ElevatedButton(
      onPressed: () {
        // Mở chat
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,
      ),
      child: Text('Message'),
    );
  }
}
