import 'package:Tracio/presentation/exploration/widgets/exploration_map_view.dart';
import 'package:Tracio/presentation/exploration/widgets/exploration_search_bar.dart';
import 'package:Tracio/presentation/exploration/widgets/exploration_map_controls.dart';
import 'package:Tracio/presentation/exploration/widgets/exploration_area_search.dart';
import 'package:Tracio/presentation/exploration/widgets/exploration_search_results.dart';
import 'package:Tracio/presentation/exploration/widgets/exploration_distance_filter.dart';
import 'package:Tracio/presentation/exploration/widgets/exploration_category_tabs.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExplorationPage extends StatefulWidget {
  const ExplorationPage({super.key});

  @override
  State<ExplorationPage> createState() => _ExplorationPageState();
}

class _ExplorationPageState extends State<ExplorationPage> {
  bool _isCentered = true;
  bool _isMapView = true;
  bool _isSearchFocused = false;
  double _selectedDistance = 0;
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchResults = [
    'Sample Location 1',
    'Sample Location 2',
    'Sample Location 3',
  ];

  void _handleCenteredChanged(bool value) {
    setState(() {
      _isCentered = value;
    });
  }

  void _toggleView() {
    setState(() {
      _isMapView = !_isMapView;
    });
  }

  void _handleMapStyleChange() {
    // TODO: Implement map style change
  }

  void _handleAreaSearch() {
    // TODO: Implement area search
  }

  void _handleSearchFocusChanged(bool isFocused) {
    setState(() {
      _isSearchFocused = isFocused;
    });
  }

  void _handleDistanceChanged(double distance) {
    setState(() {
      _selectedDistance = distance;
    });
  }

  void _handleCategoryChanged(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            ExplorationSearchBar(
              searchController: _searchController,
              isMapView: _isMapView,
              onToggleView: _toggleView,
              onFocusChanged: _handleSearchFocusChanged,
            ),
            if (_isSearchFocused)
              DefaultTabController(
                length: 4,
                child: ExplorationCategoryTabs(
                  selectedIndex: _selectedCategoryIndex,
                  onIndexChanged: _handleCategoryChanged,
                ),
              )
            else
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    ExplorationDistanceFilter(
                      initialDistance: _selectedDistance,
                      onDistanceChanged: _handleDistanceChanged,
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Stack(
                children: [
                  // Map View (always present)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isSearchFocused ? 0.0 : 1.0,
                    child: Stack(
                      children: [
                        BlocProvider(
                          create: (context) => MapCubit(),
                          child: ExplorationMapView(
                            isCentered: _isCentered,
                            onCenteredChanged: _handleCenteredChanged,
                          ),
                        ),
                        ExplorationMapControls(
                          onMapStyleChange: _handleMapStyleChange,
                          onCenterLocation: () => setState(() => _isCentered = true),
                        ),
                        ExplorationAreaSearch(
                          onSearch: _handleAreaSearch,
                        ),
                      ],
                    ),
                  ),
                  // Search Results
                  ExplorationSearchResults(
                    isVisible: _isSearchFocused,
                    searchResults: _searchResults,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
