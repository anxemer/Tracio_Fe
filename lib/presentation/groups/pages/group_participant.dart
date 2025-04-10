import 'package:flutter/material.dart';

class GroupParticipant extends StatefulWidget {
  const GroupParticipant({super.key});

  @override
  State<GroupParticipant> createState() => _GroupParticipantState();
}

class _GroupParticipantState extends State<GroupParticipant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Participants'),
      ),
    );
  }
}
