import 'package:flutter/material.dart';
import 'package:tracio_fe/presentation/map/pages/cycling.dart';
import 'package:tracio_fe/presentation/library/widgets/feature_section.dart';

class RidesTab extends StatefulWidget {
  const RidesTab({super.key});

  @override
  State<RidesTab> createState() => _RidesTabState();
}

class _RidesTabState extends State<RidesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          FeatureSection(
            banner: Image.asset("assets/images/rides.png"),
            title: "Cycling Mode",
            description:
                "Track your rides and enjoy guided cycling with real-time metrics and insights.",
            buttonText: "Start Riding",
            onPressed: () => _navigateTo(context, CyclingPage()),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
