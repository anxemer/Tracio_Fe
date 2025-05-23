import 'package:flutter/material.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';

class SnapshotEditSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final int selectedIndex;
  final VoidCallback onSave;
  final Function(int) onPrivacyChanged;

  const SnapshotEditSection({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.selectedIndex,
    required this.onSave,
    required this.onPrivacyChanged,
  });

  @override
  State<SnapshotEditSection> createState() => _SnapshotEditSectionState();
}

class _SnapshotEditSectionState extends State<SnapshotEditSection> {
  final FocusNode _nameFocusNode = FocusNode();
  late String name;
  late String desc;

  @override
  void initState() {
    super.initState();

    name = widget.nameController.text;
    desc = widget.descriptionController.text;

    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_nameFocusNode);
    });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSize.apSectionPadding),

        /// **Name Field (Auto Focus, 50 Char Limit)**
        StatefulBuilder(builder: (context, setTextFieldState) {
          return TextField(
            onChanged: (value) {
              setTextFieldState(() {
                name = value;
              });
            },
            controller: widget.nameController,
            focusNode: _nameFocusNode,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: "Name",
              counterText: "${name.length}/50",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary)),
              fillColor: Colors.grey[100],
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            ),
          );
        }),

        const SizedBox(height: AppSize.apVerticalPadding),

        /// **Description Field (250 Char Limit)**
        StatefulBuilder(builder: (context, setTextFieldState) {
          return TextField(
            controller: widget.descriptionController,
            onChanged: (value) {
              setTextFieldState(() {
                desc = value;
              });
            },
            maxLength: 250,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: "Description",
              counterText: "${desc.length}/250",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary)),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            ),
          );
        }),

        const SizedBox(height: AppSize.apSectionPadding),

        /// **Save Changes Button**
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onSave,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppColors.secondBackground,
            ),
            child: const Text(
              "Save Changes",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
