import 'package:flutter/material.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';

class SearchLocationInput extends StatefulWidget {
  const SearchLocationInput({super.key});

  @override
  State<SearchLocationInput> createState() => _SearchLocationInputState();
}

class _SearchLocationInputState extends State<SearchLocationInput> {
  final FocusNode _focusNode = FocusNode();
  double searchFieldSize = 200;
  final int animationDuration = 300;
  @override
  initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          searchFieldSize = 300;
        });
      } else {
        _focusNode.unfocus();
        setState(() {
          searchFieldSize = 200;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: animationDuration),
        width: searchFieldSize,
        child: TextField(
          cursorColor: AppColors.secondBackground,
          focusNode: _focusNode,
          onTapOutside: (PointerDownEvent event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          style:
              TextStyle(color: Colors.black54, overflow: TextOverflow.ellipsis),
          decoration: InputDecoration(
            hintText: 'Search route...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.background,
            ),
          ),
        ),
      ),
    );
  }
}
