import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';

class CustomeSearchBar extends StatefulWidget {
  const CustomeSearchBar({super.key});

  @override
  State<CustomeSearchBar> createState() => _CustomeSearchBarState();
}

class _CustomeSearchBarState extends State<CustomeSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  String _previousSearchText = "";
  void _onSearchChanged() {
    final currentText = _searchController.text.trim();

    if (currentText == _previousSearchText) return;

    setState(() {});
    _previousSearchText = currentText;
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return TextField(
      controller: _searchController,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        prefixIcon: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search_outlined),
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close),
              )
            : null,
        hintText: "Search service",
        hintStyle: TextStyle(
            color: context.isDarkMode ? Colors.white : Colors.grey[400]),
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(
                color: isDark ? Colors.white : Colors.grey.shade600)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(
                color: isDark
                    ? AppColors.secondBackground
                    : AppColors.background)),
      ),
    );
  }
}
