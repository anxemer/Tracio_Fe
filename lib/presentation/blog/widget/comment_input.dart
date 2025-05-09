import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/constants/app_size.dart';

import '../../../common/widget/blog/pick_image.dart';
import '../../../common/widget/picture/circle_picture.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../domain/auth/entities/user.dart';
import '../../../domain/blog/entites/comment_input_data.dart';
import '../../auth/bloc/authCubit/auth_cubit.dart';
import '../../auth/bloc/authCubit/auth_state.dart';

class CommentInputWidget extends StatefulWidget {
  const CommentInputWidget({
    super.key,
    required this.onSubmit,
    required this.inputData,
    required this.onReset,
  });

  final Function(String content, List<File> files, CommentInputData inputData)
      onSubmit;
  final CommentInputData inputData;
  final Function() onReset;

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _textController = TextEditingController();
  final List<File> selectedFiles = [];
  late PageController _pageController;
  CommentInputData? _prevInputData;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _prevInputData = widget.inputData;
  }

  @override
  void didUpdateWidget(CommentInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_prevInputData?.mode != widget.inputData.mode) {
      _textController.clear();
      _prevInputData = widget.inputData;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImages(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 800, // Giới hạn kích thước ảnh để tối ưu
          imageQuality: 85, // Giảm chất lượng ảnh một chút
        );

        if (pickedFile != null) {
          setState(() {
            selectedFiles.add(File(pickedFile.path));
          });
        }
      } else if (source == ImageSource.camera) {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1024,
          imageQuality: 85,
        );

        if (pickedFile != null) {
          setState(() {
            selectedFiles.add(File(pickedFile.path));
          });
        }
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

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('select from library'),
                onTap: () {
                  _pickImages(ImageSource.gallery);
                  Navigator.of(ctx).pop();
                }),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a new photo'),
              onTap: () {
                _pickImages(ImageSource.camera);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onRemoveImage(int index) {
    setState(() {
      selectedFiles.removeAt(index);
      if (selectedFiles.isNotEmpty && index >= selectedFiles.length) {
        _pageController.jumpToPage(selectedFiles.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    UserEntity? user;

    if (state is AuthLoaded) {
      user = state.user;
    } else if (state is AuthChangeRole) {
      user = state.user;
    }
    final inputData = widget.inputData;

    return Container(
      color: context.isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      // padding: EdgeInsets.only(
      //     left: 16.w,
      //     right: 16.w,
      //     top: 8.h,
      //     bottom: MediaQuery.of(context).viewInsets.bottom + 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (inputData.mode != CommentMode.blogComment)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: context.isDarkMode ? Colors.white : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to ${inputData.replyToUserName}',
                      style: TextStyle(
                        fontSize: AppSize.textMedium.sp,
                        fontWeight: FontWeight.w500,
                        color: inputData.mode == CommentMode.replyComment
                            ? Colors.blue
                            : Colors.purple,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onReset,
                    child: Icon(
                      Icons.close,
                      size: AppSize.iconMedium.sp,
                      color: context.isDarkMode ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

          if (selectedFiles.isNotEmpty)
            SizedBox(
              height: 150.h,
              child: SelectedImagesViewer(
                widgeImage: AppSize.imageLarge.w,
                selectedFiles: selectedFiles,
                onRemoveImage: _onRemoveImage,
                pageController: _pageController,
              ),
            ),

          // Input container
          Container(
            height: AppSize.bottomNavBarHeight * 0.8.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60.sp),
                border: Border.all(
                    color: context.isDarkMode ? Colors.white : Colors.black45,
                    width: 1.w)),
            child: Row(
              children: [
                SizedBox(width: 8.w),
                ClipOval(
                  child: CirclePicture(
                      imageUrl: user!.profilePicture!,
                      imageSize: AppSize.iconSmall.sp),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(
                        color:
                            context.isDarkMode ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      hintText: inputData.hintText,
                      fillColor:
                          context.isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      // border: InputBorder.none,
                    ),
                  ),
                ),

                // Image picker button
                IconButton(
                  icon: Icon(
                    Icons.image_outlined,
                    size: AppSize.iconLarge.sp,
                    color: context.isDarkMode
                        ? Colors.white
                        : Colors.grey.shade700,
                  ),
                  onPressed: () {
                    _showImageSourceDialog();
                  },
                ),

                // Send button
                IconButton(
                  icon: Icon(
                    Icons.send_rounded,
                    color: context.isDarkMode
                        ? AppColors.primary
                        : AppColors.background,
                    size: AppSize.iconLarge.sp,
                  ),
                  onPressed: () {
                    if (_textController.text.trim().isNotEmpty ||
                        selectedFiles.isNotEmpty) {
                      widget.onSubmit(
                        _textController.text,
                        List.from(selectedFiles),
                        widget.inputData,
                      );

                      _textController.clear();
                      setState(() {
                        selectedFiles.clear();
                      });

                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
