import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';
import 'package:uuid/uuid.dart';

class SearchLocationInput extends StatefulWidget {
  const SearchLocationInput({super.key});

  @override
  State<SearchLocationInput> createState() => _SearchLocationInputState();
}

class _SearchLocationInputState extends State<SearchLocationInput> {
  final TextEditingController _searchController = TextEditingController();

  final Uuid _uuid = Uuid();
  String _sessionToken = "";
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

    if (_sessionToken.isEmpty) {
      _sessionToken = _uuid.v4();
    }

    setState(() {});
    _previousSearchText = currentText;
    context
        .read<GetLocationCubit>()
        .getLocationsAutoComplete(currentText, sessionToken: _sessionToken);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      color: Colors.grey.shade700,
      child: TextField(
        controller: _searchController,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _sessionToken = "";
                    context.read<GetLocationCubit>().clearSearchResults();
                    setState(() {});
                  },
                  icon: const Icon(Icons.close),
                )
              : null,
          hintText: "Find Location",
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ),
    );
  }
}
