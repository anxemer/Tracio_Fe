import 'package:flutter/material.dart';
import 'package:Tracio/core/constants/app_size.dart';

class ConversationSearchBox extends StatefulWidget {
  const ConversationSearchBox({super.key});

  @override
  State<ConversationSearchBox> createState() => _ConversationSearchBoxState();
}

class _ConversationSearchBoxState extends State<ConversationSearchBox> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: AppSize.apHorizontalPadding / 2,
          vertical: AppSize.apVerticalPadding),
      child: TextField(
        focusNode: _focusNode,
        onTapOutside: (event) {
          _focusNode.unfocus();
        },
        decoration: InputDecoration(
          hintText: "Search conversations...",
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
