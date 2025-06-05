import 'package:flutter/material.dart';

class ExplorationAreaSearch extends StatelessWidget {
  final VoidCallback onSearch;

  const ExplorationAreaSearch({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: Center(
        child: FloatingActionButton.small(
          onPressed: onSearch,
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
} 