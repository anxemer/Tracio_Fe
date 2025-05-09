import 'package:Tracio/core/services/signalR/implement/matching_hub_service.dart';
import 'package:Tracio/data/map/models/matched_user.dart';
import 'package:Tracio/domain/map/entities/matched_user.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/tracking/bloc/tracking_bloc.dart';
import 'package:Tracio/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CyclingTrackingDrawer extends StatefulWidget {
  final List<MatchedUserEntity> matchedUsers;

  const CyclingTrackingDrawer({super.key, required this.matchedUsers});

  @override
  State<CyclingTrackingDrawer> createState() => _CyclingTrackingDrawerState();
}

class _CyclingTrackingDrawerState extends State<CyclingTrackingDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void toggleDrawer() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.matchedUsers.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        // Outside tap detector (only when drawer is open)
        if (_isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: toggleDrawer, // tap outside to close
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),

        // Toggle Button
        Positioned(
          top: 100,
          right: 0,
          child: GestureDetector(
            onTap: toggleDrawer,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
              ),
              child: Icon(_isOpen ? Icons.close : Icons.people_alt),
            ),
          ),
        ),

        // Sliding Panel
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: 240,
                height: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.white,
                child: ListView.separated(
                  itemCount: widget.matchedUsers.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, index) {
                    final user = widget.matchedUsers[index];
                    return Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.avatar),
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            user.userName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            var matchingUsers =
                                sl<MatchingHubService>().matchingUser;
                            var otherUser = matchingUsers.firstWhere(
                              (element) => element.otherUserId == user.userId,
                            );

                            sl<MatchingHubService>().approveMatch(
                              ApproveMatchModel(
                                userId: otherUser.userId,
                                routeId: otherUser.routeId,
                                otherUserId: otherUser.otherUserId,
                                otherRouteId: otherUser.otherRouteId,
                                status: 'Rejected',
                              ),
                            );
                            context.read<TrackingBloc>().add(
                                  RemoveMatchedUser(otherUser.otherUserId),
                                );
                            context
                                .read<MapCubit>()
                                .pointAnnotationManager
                                ?.deleteAll();
                          },
                          child: const Icon(Icons.logout, size: 16),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
