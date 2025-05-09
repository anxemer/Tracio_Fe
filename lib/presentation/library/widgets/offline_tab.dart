import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Tracio/presentation/library/widgets/feature_section.dart';

class OfflineTab extends StatefulWidget {
  const OfflineTab({super.key});

  @override
  State<OfflineTab> createState() => _OfflineTabState();
}

class _OfflineTabState extends State<OfflineTab>
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
          banner: Image.asset("assets/images/offline.png"),
          title: "Go Offline",
          description:
              "Download your routes to your using Tracio app, and navigate without the need for a data connection.",
          buttonText: "Download Routes",
          onPressed: () => {},
        ),
      ],
    ));
  }
}
