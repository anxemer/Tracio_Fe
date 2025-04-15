import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tracio_fe/presentation/library/widgets/feature_section.dart';

class SavedTab extends StatefulWidget {
  const SavedTab({super.key});

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab>
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
            banner: Image.asset("assets/images/saved.png"),
            title: "Save Your Favorites",
            description:
                "Find routes and rides using this app to easily access your favorite ones whenever, wherever",
            buttonText: "Find Your Favorites",
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
