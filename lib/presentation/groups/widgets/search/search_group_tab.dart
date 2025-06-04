import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/presentation/groups/cubit/group_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/group_state.dart';
import 'package:Tracio/presentation/groups/widgets/search/search_group_list.dart';
import 'package:Tracio/data/groups/models/request/get_group_list_req.dart';
import 'package:easy_debounce/easy_debounce.dart';

class SearchGroupTab extends StatefulWidget {
  const SearchGroupTab({super.key});

  @override
  State<SearchGroupTab> createState() => _SearchGroupTabState();
}

class _SearchGroupTabState extends State<SearchGroupTab> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedLocation;
  final _debounceTime = const Duration(milliseconds: 300);

  final List<String> _locations = [
    'All Locations',
    'Hanoi',
    'Ho Chi Minh',
    'Da Nang',
    'Hai Phong',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    EasyDebounce.debounce(
      'search_groups',
      _debounceTime,
      () {
        if (mounted) {
          context.read<GroupCubit>().getGroupList(
                GetGroupListReq(
                  pageNumber: 1,
                  pageSize: 15,
                  getMyGroups: false,
                  searchName: _searchController.text.trim(),
                  location: _selectedLocation == 'All Locations' ? null : _selectedLocation,
                ),
              );
        }
      },
    );
  }

  void _onLocationChanged(String? location) {
    setState(() {
      _selectedLocation = location;
    });
    _onSearchChanged();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    EasyDebounce.cancel('search_groups');
    super.dispose();
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
              hintText: 'Search groups...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ),
        // Location Filter Chips
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location',
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
                children: _locations.map((location) {
                  final isSelected = _selectedLocation == location;
                  return FilterChip(
                    label: Text(location),
                    selected: isSelected,
                    onSelected: (selected) {
                      _onLocationChanged(selected ? location : null);
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
        ),
        // Group List
        Expanded(
          child: BlocBuilder<GroupCubit, GroupState>(
            builder: (context, state) {
              if (state is GroupLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              if (state is GroupFailure) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.sp,
                    ),
                  ),
                );
              }

              if (state is GetGroupListSuccess) {
                if (state.groupList.isEmpty) {
                  return Center(
                    child: Text(
                      'No groups found',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }

                return SearchGroupList(
                  groups: state.groupList,
                  hasNextPage: state.hasNextPage,
                  currentPage: state.pageNumber,
                  pageSize: state.pageSize,
                  searchName: _searchController.text.trim(),
                  location: _selectedLocation == 'All Locations' ? null : _selectedLocation,
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
