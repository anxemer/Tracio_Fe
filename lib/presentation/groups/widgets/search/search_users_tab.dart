import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchUsersTab extends StatefulWidget {
  const SearchUsersTab({super.key});

  @override
  State<SearchUsersTab> createState() => _SearchUsersTabState();
}

class _SearchUsersTabState extends State<SearchUsersTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Field
        Padding(
          padding: EdgeInsets.all(16.w),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            onChanged: (value) {
              // Implement search logic here
            },
          ),
        ),
        // User List
        Expanded(
          child: ListView.builder(
            itemCount: 0, // Replace with actual user list
            itemBuilder: (context, index) {
              return const UserListItem(
                name: 'User Name',
                avatarUrl: 'https://example.com/avatar.jpg',
                isFollowing: false,
              );
            },
          ),
        ),
      ],
    );
  }
}

class UserListItem extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final bool isFollowing;

  const UserListItem({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(25.r),
            child: CachedNetworkImage(
              imageUrl: avatarUrl,
              width: 50.w,
              height: 50.w,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.person),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '@${name.toLowerCase().replaceAll(' ', '')}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Follow Button
          TextButton(
            onPressed: () {
              // Implement follow/unfollow logic
            },
            style: TextButton.styleFrom(
              backgroundColor: isFollowing ? Colors.grey[200] : AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              isFollowing ? 'Following' : 'Follow',
              style: TextStyle(
                color: isFollowing ? Colors.black87 : Colors.white,
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