import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/map/widgets/snapshot_edit_section.dart';
import 'package:tracio_fe/presentation/map/widgets/snapshot_review_section.dart';

class SnapshotDisplayPage extends StatefulWidget {
  final Uri snapshotImage;
  final Widget metricsSection;
  final String? routeName;
  final String? routeDesc;

  const SnapshotDisplayPage(
      {super.key,
      required this.snapshotImage,
      required this.metricsSection,
      this.routeName,
      this.routeDesc});

  @override
  State<SnapshotDisplayPage> createState() => _SnapshotDisplayPageState();
}

class _SnapshotDisplayPageState extends State<SnapshotDisplayPage> {
  bool _isEditing = false;
  double _containerHeight = 170.h;

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.routeName ?? "");
    _descriptionController =
        TextEditingController(text: widget.routeDesc ?? "");
  }

  void _slideUpToEdit(double height) {
    setState(() {
      _isEditing = true;
      _containerHeight = height.h;
    });
  }

  void _slideDown() {
    setState(() {
      _isEditing = false;
      _containerHeight = 170.h;
    });
  }

  void _saveChanges() {
    Navigator.pop(context, {
      "routeName": _nameController.text,
      "routeDescription": _descriptionController.text,
      "routePrivacy": _selectedIndex,
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            /// **Background Image**
            Positioned.fill(
              bottom: 170.h,
              child: Image.network(
                widget.snapshotImage.toString(),
                fit: BoxFit.fill,
              ),
            ),

            /// **Back Button**
            Positioned(
              top: 16,
              left: 16,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () {
                    if (_isEditing) {
                      _slideDown();
                    } else {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context, 'canceled');
                      }
                    }
                  },
                ),
              ),
            ),

            /// **Bottom Slide-Up Panel**
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: _containerHeight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.apHorizontalPadding,
                    vertical: AppSize.apVerticalPadding,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: _isEditing
                        ? SnapshotEditSection(
                            nameController: _nameController,
                            descriptionController: _descriptionController,
                            selectedIndex: _selectedIndex,
                            onSave: _saveChanges,
                            onPrivacyChanged: (index) {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                          )
                        : SnapshotReviewSection(
                            metricsSection: widget.metricsSection,
                            onEdit: () {
                              _slideUpToEdit(
                                  MediaQuery.of(context).size.height * 0.7);
                            },
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
