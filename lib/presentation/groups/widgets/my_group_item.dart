import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/groups/entities/group.dart';
import 'package:Tracio/presentation/groups/cubit/invitation_bloc.dart';
import 'package:Tracio/presentation/groups/pages/group_detail.dart';
import 'package:Tracio/presentation/map/bloc/tracking/bloc/tracking_bloc.dart';

class MyGroupItem extends StatefulWidget {
  final Group group;

  const MyGroupItem({super.key, required this.group});

  @override
  State<MyGroupItem> createState() => _MyGroupItemState();
}

class _MyGroupItemState extends State<MyGroupItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            tileColor: Colors.white,
            contentPadding: EdgeInsets.all(AppSize.apHorizontalPadding * 0.5),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.group.groupThumbnail,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              widget.group.groupName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.group.participantCount}/${widget.group.maxParticipants} members',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '${widget.group.city}, ${widget.group.district}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<TrackingBloc>(context),
                    child: BlocProvider.value(
                      value: BlocProvider.of<InvitationBloc>(context),
                      child: GroupDetailScreen(
                        groupId: widget.group.groupId,
                      ),
                    ),
                  ),
                ),
              );
            }),
        Divider(
          height: 0.1,
        )
      ],
    );
  }
}
