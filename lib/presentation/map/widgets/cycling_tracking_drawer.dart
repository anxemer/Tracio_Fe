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
              onTap: toggleDrawer,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),

        // Toggle Button with badge
        Positioned(
          top: 100,
          right: 0,
          child: GestureDetector(
            onTap: toggleDrawer,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black26,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Icon(_isOpen ? Icons.close : Icons.people_alt),
                  if (!_isOpen && widget.matchedUsers.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          widget.matchedUsers.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
                width: 280,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.blue.shade100,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people_alt, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Riding Together (${widget.matchedUsers.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // User List
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: widget.matchedUsers.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, index) {
                          final user = widget.matchedUsers[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(user.avatar),
                              radius: 24,
                            ),
                            title: Text(
                              user.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: const Text(
                              'Riding together',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.logout, size: 20),
                              color: Colors.red,
                              tooltip: 'Unmatch',
                              onPressed: () {
                                var matchingUsers =
                                    sl<MatchingHubService>().matchingUser;
                                var otherUser = matchingUsers.firstWhere(
                                  (element) =>
                                      element.otherUserId == user.userId,
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
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
