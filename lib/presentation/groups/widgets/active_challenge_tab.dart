import 'package:flutter/material.dart';

class ActiveChallengeTab extends StatefulWidget {
  const ActiveChallengeTab({super.key});

  @override
  State<ActiveChallengeTab> createState() => _ActiveChallengeTabState();
}

class _ActiveChallengeTabState extends State<ActiveChallengeTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [Placeholder()],
      ),
    );
  }
}
