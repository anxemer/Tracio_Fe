import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/common/widget/input_text_form_field.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/blog/models/response/category_model.dart';
import 'package:Tracio/data/shop/models/create_service_req.dart';
import 'package:Tracio/domain/blog/entites/category.dart';
import 'package:Tracio/domain/shop/entities/response/shop_service_entity.dart';
import 'package:Tracio/presentation/blog/bloc/category/get_category_cubit.dart';
import 'package:Tracio/presentation/shop_owner/bloc/service_management/service_management_cubit.dart';
import 'package:Tracio/presentation/shop_owner/page/dash_board.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../blog/bloc/category/get_category_state.dart';

class CreateEditServiceScreen extends StatefulWidget {
  final ShopServiceEntity? initialData;
  final bool isEditing;
  final int shopId;

  const CreateEditServiceScreen({
    super.key,
    this.initialData,
    this.isEditing = false,
    required this.shopId, // Bắt buộc phải có shopId
  });

  @override
  State<CreateEditServiceScreen> createState() =>
      _CreateEditServiceScreenState();
}

class _CreateEditServiceScreenState extends State<CreateEditServiceScreen> {
  List<CategoryEntity> _categories = [];
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;

  // State variables
  int? _selectedCategoryId;
  // int? _selectedDuration;
  List<File> _selectedImageFiles = [];
  List<String> _existedImage = [];

  @override
  void initState() {
    super.initState();
    // List<String> mediaUrls = widget.initialData?.mediaFiles!
    //     .map((file) => file.mediaUrl ?? "")
    //     .toList();

    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _durationController = TextEditingController();

    if (widget.isEditing && widget.initialData != null) {
      final data = widget.initialData!;
      _nameController.text = data.serviceName!;
      _descriptionController.text = data.description!;
      _priceController.text = data.formattedPrice;
      // _existedImage = mediaUrls;
      // _selectedCategoryId = _categories.;
      _durationController.text = data.formattedDuration;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImageFiles
              .addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Can\'t pick picture! please check permission')),
        );
      }
    }
  }

  void _removeNewImage(int index) {
    setState(() {
      _selectedImageFiles.removeAt(index);
    });
  }

  void _removeExistingImage(String url) {
    setState(() {
      _existedImage.remove(url);
    });
    print(
        "TODO: Implement logic to permanently delete existing image with url: $url from server if needed");
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final categoryId = _selectedCategoryId;
      final duration = _durationController.text;
      final newImages = _selectedImageFiles;

     
      if (!widget.isEditing) {
        context.read<ServiceManagementCubit>().createService(CreateServiceReq(
            shopId: widget.shopId,
            categoryId: categoryId!,
            nameService: name,
            description: description,
            price: price,
            duration: duration,
            mediaFiles: newImages));
      }
  

      // if (Navigator.canPop(context)) { Navigator.pop(context); }
    } else {
      print("Form invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return BlocListener<ServiceManagementCubit, ServiceManagementState>(
      listener: (context, state) {
        if (state is CreateServiceSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.isEditing
                  ? 'Update Service Success!'
                  : 'Create Service Success!'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            widget.isEditing ? 'Edit Service' : 'Create Service',
            style: TextStyle(
                fontSize: AppSize.textHeading.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white70),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 4.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Category ---
                BlocBuilder<GetCategoryCubit, GetCategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoaded) {
                      _categories = state.categories;

                      if (widget.isEditing &&
                          widget.initialData != null &&
                          _selectedCategoryId == null) {
                        final matched = _categories.firstWhere(
                          (c) =>
                              c.categoryName ==
                              widget.initialData!.categoryName,
                          orElse: () =>
                              CategoryModel(categoryId: -1, categoryName: ''),
                        );
                        if (matched.categoryId != -1) {
                          _selectedCategoryId = matched.categoryId;
                        }
                      }
                      return _buildDropdownField(
                        value: _selectedCategoryId,
                        items: state.categories.map((category) {
                          return DropdownMenuItem<int>(
                            value: category.categoryId,
                            child: Text(category.categoryName!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                        labelText: 'Category Service *',
                        hintText: 'Choose Category',
                        validator: (value) =>
                            value == null ? 'Plesae choose category' : null,
                      );
                    }
                    return LoadingAnimationWidget.fourRotatingDots(
                      color: AppColors.secondBackground,
                      size: AppSize.iconExtraLarge,
                    );
                  },
                ),

                // --- Name ---
                InputTextFormField(
                  controller: _nameController,
                  labelText: 'Service Name *',
                  hint: 'Service Name',
                  prefixIcon: Icon(Icons.design_services_outlined),
                  validation: (value) => (value == null || value.isEmpty)
                      ? 'Please Enter Name Service Name'
                      : null,
                ),

                // --- Description ---
                InputTextFormField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  hint: 'Enter Desciption for this service',
                  prefixIcon: Icon(Icons.notes_outlined),
                  maxLine: 3,
                  // validator: optional
                ),

                // --- Price & Duration Row ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InputTextFormField(
                        controller: _priceController,
                        labelText: 'Price (VNĐ) *',
                        hint: 'Enter Price',
                        prefixIcon: Icon(Icons.attach_money_outlined),
                        keyBoardType: const TextInputType.numberWithOptions(
                            decimal: false),
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter Price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Price Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: InputTextFormField(
                        controller: _durationController,
                        labelText: 'Duration (Minute) *',
                        hint: 'Input Duration',
                        prefixIcon: Icon(Icons.timer_outlined),
                        keyBoardType: TextInputType.number,
                        validation: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter duration';
                          final minutes = int.tryParse(value);
                          if (minutes == null) return 'Minute invalid';
                          if (minutes <= 0)
                            return 'time must be greater than 0';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                Text("Servie picture", style: textTheme.titleMedium),
                const SizedBox(height: 12.0),

                // --- Image Picker Button ---
                Center(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: const Text('Add Picture'),
                    onPressed: _pickImages,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      side: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // --- Image Preview Section ---
                _buildImagePreview(), // Widget hiển thị ảnh đã chọn

                const SizedBox(height: 32.0),

                // --- Save Button (Bottom) ---
                BlocBuilder<ServiceManagementCubit, ServiceManagementState>(
                  builder: (context, state) {
                    if (state is CreateServiceLoading) {
                      return LoadingAnimationWidget.fourRotatingDots(
                        color: AppColors.secondBackground,
                        size: AppSize.iconExtraLarge,
                      );
                    }
                    return Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: Text(widget.isEditing
                            ? 'Save Change'
                            : 'Create Service'),
                        onPressed: _saveForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          textStyle: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildImagePreview() {
    if (_selectedImageFiles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: [
          // ..._existedImage.map((url) => _buildImageThumbnail(
          //       imageProvider: NetworkImage(url), // Dùng NetworkImage
          //       onRemove: () => _removeExistingImage(url),
          //     )),
          ..._selectedImageFiles.asMap().entries.map((entry) {
            int index = entry.key;
            File file = entry.value;
            return _buildImageThumbnail(
              imageProvider: FileImage(file),
              onRemove: () => _removeNewImage(index),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildImageThumbnail(
      {required ImageProvider imageProvider, required VoidCallback onRemove}) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Ảnh thumbnail
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
            ),
          ),
          Positioned(
            top: -8,
            right: -8,
            child: Material(
              color: Colors.redAccent.withOpacity(0.8),
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              elevation: 1,
              child: InkWell(
                splashColor: Colors.white.withOpacity(0.4),
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(3.0),
                  child:
                      Icon(Icons.close_rounded, color: Colors.white, size: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required String labelText,
    required String hintText,
    String? Function(T?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        ),
      ),
    );
  }
}
