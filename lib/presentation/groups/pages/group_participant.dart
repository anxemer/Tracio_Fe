import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

class GroupParticipant extends StatefulWidget {
  const GroupParticipant({super.key});

  @override
  State<GroupParticipant> createState() => _GroupParticipantState();
}

class _GroupParticipantState extends State<GroupParticipant> {
  final List<Map<String, String>> members = [
    {
      "name": "Loc Minh Tran",
      "city": "Go Vap, Binh Duong",
      "avatar": "https://i.pravatar.cc/150?img=1",
    },
    {
      "name": "Huy Tran",
      "city": "Go Vap, Ho Chi Minh",
      "avatar": "https://i.pravatar.cc/150?img=2",
    },
  ];

  final List<Map<String, String>> admins = [
    {
      "name": "Nguyen Minh Loc",
      "city": "Di An, Binh Duong",
      "avatar": "https://i.pravatar.cc/150?img=3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Group Participants'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Members'),
              Tab(text: 'Admins'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.apHorizontalPadding,
                    vertical: 12.0,
                  ),
                  color: Colors.grey.shade300,
                  child: Text(
                    "Members",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: AppSize.textMedium.sp,
                    ),
                  ),
                ),
                Expanded(child: _buildParticipantList(members)),
              ],
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.apHorizontalPadding,
                    vertical: 12.0,
                  ),
                  color: Colors.grey.shade300,
                  child: Text(
                    "Owner",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: AppSize.textMedium.sp,
                    ),
                  ),
                ),
                Expanded(child: _buildParticipantList(admins)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantList(List<Map<String, String>> participants) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: participants.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final user = participants[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: CachedNetworkImageProvider(user["avatar"]!),
          ),
          title: Text(user["name"] ?? ''),
          subtitle: Text(user["city"] ?? ''),
          trailing: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.secondBackground),
                borderRadius: BorderRadius.circular(5.0)),
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Followed ${user['name']}")),
                );
              },
              child: Text(
                "Follow",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ),
        );
      },
    );
  }
}
