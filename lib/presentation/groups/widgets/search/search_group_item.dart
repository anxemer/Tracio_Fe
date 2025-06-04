import 'package:Tracio/presentation/groups/cubit/invitation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Tracio/domain/groups/entities/group.dart';
import 'package:Tracio/presentation/groups/pages/group_detail.dart';

class SearchGroupItem extends StatelessWidget {
  final Group group;

  const SearchGroupItem({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => InvitationBloc(),
              child: GroupDetailScreen(groupId: group.groupId),
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            // Group Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: group.groupThumbnail,
                width: 40.w,
                height: 40.w,
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
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${group.participantCount} participants • ${group.city}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
