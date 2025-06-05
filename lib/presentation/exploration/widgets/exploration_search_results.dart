import 'package:flutter/material.dart';

class ExplorationSearchResults extends StatelessWidget {
  final bool isVisible;
  final List<String> searchResults;

  const ExplorationSearchResults({
    super.key,
    required this.isVisible,
    this.searchResults = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isVisible ? 1.0 : 0.0,
      child: Container(
        color: Colors.black87,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.location_on, color: Colors.white70),
              title: Text(
                searchResults[index],
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                // TODO: Handle location selection
              },
            );
          },
        ),
      ),
    );
  }
} 