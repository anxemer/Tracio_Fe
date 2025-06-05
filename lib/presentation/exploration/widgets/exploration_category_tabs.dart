import 'package:flutter/material.dart';

class ExplorationCategoryTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  const ExplorationCategoryTabs({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: TabBar(
        onTap: onIndexChanged,
        indicatorColor: Colors.blue,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Places'),
          Tab(text: 'Routes'),
          Tab(text: 'Shops'),
        ],
      ),
    );
  }
} 