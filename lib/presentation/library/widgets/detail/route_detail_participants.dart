import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/map/entities/route_detail.dart';

class RouteDetailParticipants extends StatelessWidget {
  final RouteDetailEntity routeDetail;
  final List<MatchedUser>? matchedUsers;
  final List<Participant>? participants;
  final bool isOwner;

  const RouteDetailParticipants({
    super.key,
    required this.routeDetail,
    this.matchedUsers,
    this.participants,
    required this.isOwner,
  });

  String _getRoleTitle() {
    if (isOwner) {
      if (matchedUsers?.isNotEmpty ?? false) {
        return 'Route Matches';
      } else if (participants?.isNotEmpty ?? false) {
        return 'Group Ride';
      }
      return 'Solo Ride';
    } else if (participants?.isNotEmpty ?? false) {
      return 'Group Ride';
    } else {
      return 'Solo Ride';
    }
  }

  String _getRoleDescription() {
    if (isOwner) {
      if (matchedUsers?.isNotEmpty ?? false) {
        return 'You\'ve discovered cyclists riding on the same route';
      } else if (participants?.isNotEmpty ?? false) {
        return 'You are riding with ${participants?.length} cyclists';
      }
      return 'You can match with nearby cyclists on your route';
    } else if (participants?.isNotEmpty ?? false) {
      return '${routeDetail.cyclistName} invited cyclists to ride together';
    } else {
      return '${routeDetail.cyclistName} is riding solo on this route';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasMatchedUsers = matchedUsers?.isNotEmpty ?? false;
    final hasParticipants = participants?.isNotEmpty ?? false;

    if (!hasMatchedUsers && !hasParticipants) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
          child: Text(
            'Participants',
            style: TextStyle(
              fontSize: AppSize.textLarge.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (hasMatchedUsers) ...[
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
            child: Text(
              'Matched Riders',
              style: TextStyle(
                fontSize: AppSize.textMedium.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
              itemCount: matchedUsers!.length,
              itemBuilder: (context, index) {
                final user = matchedUsers![index];
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.w),
                              child: Image.network(
                                user.userAvatar,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.person,
                                        color: Colors.grey[600]),
                                  );
                                },
                              ),
                            ),
                          ),
                          if (user.status == 'active')
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 12.w,
                                height: 12.w,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        user.userName,
                        style: TextStyle(
                          fontSize: AppSize.textSmall.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
        if (hasParticipants) ...[
          SizedBox(height: 16.h),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getRoleTitle(),
                  style: TextStyle(
                    fontSize: AppSize.textMedium.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _getRoleDescription(),
                  style: TextStyle(
                    fontSize: AppSize.textSmall.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
              itemCount: participants!.length,
              itemBuilder: (context, index) {
                final participant = participants![index];
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Column(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.w),
                          child: Image.network(
                            participant.userAvatar,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child:
                                    Icon(Icons.person, color: Colors.grey[600]),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        participant.userName,
                        style: TextStyle(
                          fontSize: AppSize.textSmall.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
        SizedBox(height: 24.h),
      ],
    );
  }
}
