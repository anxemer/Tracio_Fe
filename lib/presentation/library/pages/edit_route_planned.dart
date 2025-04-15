import 'package:flutter/material.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/map/entities/route.dart';

class EditRoutePlannedScreen extends StatefulWidget {
  final RouteEntity routeData;

  const EditRoutePlannedScreen({super.key, required this.routeData});

  @override
  State<EditRoutePlannedScreen> createState() => _EditRoutePlannedScreenState();
}

class _EditRoutePlannedScreenState extends State<EditRoutePlannedScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  final List<String> _options = ["Public", "Private"];
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.routeData.routeName);
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    print("Updated Route Name: ${_nameController.text}");
    print("Updated Description: ${_descriptionController.text}");
    // TODO: Implement API call or Bloc event to update route details
  }

  String resizeMapboxThumbnail(String url,
      {int width = 360, int height = 200}) {
    // Regular expression to find the dimensions pattern in the URL
    final RegExp dimensionPattern = RegExp(r'/auto/\d+x\d+\?');

    // New dimensions
    final String newSize = '/auto/${width}x$height?';

    // Replace old dimensions with new dimensions
    return url.replaceFirst(dimensionPattern, newSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text("Save", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Image.network(
              scale: 0.5,
              resizeMapboxThumbnail(
                widget.routeData.routeThumbnail,
              ),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child:
                      const Center(child: Icon(Icons.broken_image, size: 50))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.apHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSize.apSectionPadding),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: AppSize.apVerticalPadding),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: AppSize.apSectionPadding),

                  Text("Route privacy"),
                  const SizedBox(height: AppSize.apVerticalPadding),
                  ToggleButtons(
                    isSelected: List.generate(
                        _options.length, (index) => index == _selectedIndex),
                    onPressed: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(50),
                    borderWidth: 1.5,
                    borderColor: Colors.grey,
                    selectedBorderColor: Colors.blue,
                    fillColor: Colors.blue.withAlpha(2),
                    color: Colors.black87,
                    selectedColor: Colors.blue,
                    constraints:
                        const BoxConstraints(minHeight: 40, minWidth: 100),
                    children: _options
                        .map((label) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(label,
                                  style: const TextStyle(fontSize: 14)),
                            ))
                        .toList(),
                  ),

                  /// Save Changes Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text("Save Changes"),
                    ),
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
