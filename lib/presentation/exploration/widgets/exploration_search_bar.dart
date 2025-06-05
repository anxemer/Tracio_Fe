import 'package:flutter/material.dart';

class ExplorationSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final bool isMapView;
  final VoidCallback onToggleView;
  final ValueChanged<bool> onFocusChanged;

  const ExplorationSearchBar({
    super.key,
    required this.searchController,
    required this.isMapView,
    required this.onToggleView,
    required this.onFocusChanged,
  });

  @override
  State<ExplorationSearchBar> createState() => _ExplorationSearchBarState();
}

class _ExplorationSearchBarState extends State<ExplorationSearchBar> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    widget.onFocusChanged(_focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.searchController,
              focusNode: _focusNode,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search location...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: IconButton(
                  icon: Icon(
                    _focusNode.hasFocus ? Icons.arrow_back : Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_focusNode.hasFocus) {
                      _focusNode.unfocus();
                      widget.searchController.clear();
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          if (!_focusNode.hasFocus) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: widget.onToggleView,
              icon: Icon(widget.isMapView ? Icons.list : Icons.map, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
} 