import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';

class SearchChallengeTab extends StatefulWidget {
  const SearchChallengeTab({super.key});

  @override
  State<SearchChallengeTab> createState() => _SearchChallengeTabState();
}

class _SearchChallengeTabState extends State<SearchChallengeTab> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedChallengeType;
  String? _selectedDistance;
  String? _selectedTime;

  final List<String> _challengeTypes = [
    'All Types',
    'Running',
    'Cycling',
    'Walking',
    'Swimming',
  ];

  final List<String> _distances = [
    'All Distances',
    '0-5 km',
    '5-10 km',
    '10-20 km',
    '20+ km',
  ];

  final List<String> _times = [
    'All Times',
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildFilterSection(String title, List<String> options, String? selectedValue, Function(String?) onSelected) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: options.map((option) {
              final isSelected = selectedValue == option;
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  onSelected(selected ? option : null);
                },
                backgroundColor: Colors.grey[200],
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.black87,
                  fontSize: 14.sp,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Field
        Padding(
          padding: EdgeInsets.all(16.w),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search challenges...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            onChanged: (value) {
              // Implement search logic here
            },
          ),
        ),
        // Filter Chips
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterSection(
                  'Challenge Type',
                  _challengeTypes,
                  _selectedChallengeType,
                  (value) => setState(() => _selectedChallengeType = value),
                ),
                _buildFilterSection(
                  'Distance',
                  _distances,
                  _selectedDistance,
                  (value) => setState(() => _selectedDistance = value),
                ),
                _buildFilterSection(
                  'Time',
                  _times,
                  _selectedTime,
                  (value) => setState(() => _selectedTime = value),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
