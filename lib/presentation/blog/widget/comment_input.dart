import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widget/blog/pick_image.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../domain/blog/entites/comment_input_data.dart';

class CommentInputWidget extends StatefulWidget {
  const CommentInputWidget({
    super.key,
    required this.onSubmit,
    required this.inputData,
    required this.onReset, // Thêm callback để reset
  });

  final Function(String content, List<File> files, CommentInputData inputData)
      onSubmit;
  final CommentInputData inputData;
  final Function() onReset;

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> {
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

  void _onImageToggle(File file, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedFiles.add(file);
        Navigator.pop(context);
      } else {
        selectedFiles.remove(file);
      }
    });
  }

  void _onImageCaptured(File file) {
    setState(() {
      selectedFiles.add(file);
    });
    _pageController.animateToPage(
      selectedFiles.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
    final inputData = widget.inputData;

    // Color borderColor;
    // Color sendIconColor;

    // switch (inputData.mode) {
    //   case CommentMode.blogComment:
    //     borderColor = Colors.black45;
    //     sendIconColor = AppColors.background;
    //     break;
    //   case CommentMode.replyComment:
    //     borderColor = Colors.blue;
    //     sendIconColor = Colors.blue;
    //     break;
    //   case CommentMode.replyToReply:
    //     borderColor = Colors.purple;
    //     sendIconColor = Colors.purple;
    //     break;
    // }

    return Container(
      color: Colors.white,
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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to ${inputData.replyToUserName}',
                      style: TextStyle(
                        fontSize: 32.sp,
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
                      size: 36.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

          if (selectedFiles.isNotEmpty)
            SizedBox(
              height: 150.h,
              child: SelectedImagesViewer(
                widgeImage: 120.w,
                selectedFiles: selectedFiles,
                onRemoveImage: _onRemoveImage,
                pageController: _pageController,
              ),
            ),

          // Input container
          Container(
            height: 120.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60.sp),
                border: Border.all(color: Colors.black45, width: 1.w)),
            child: Row(
              children: [
                SizedBox(width: 8.w),
                ClipOval(
                  child: SizedBox(
                    width: 80.w,
                    height: 80.h,
                    child: Image.asset(AppImages.man),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: inputData.hintText,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      // border: InputBorder.none,
                    ),
                  ),
                ),

                // Image picker button
                IconButton(
                  icon: Icon(
                    Icons.image_outlined,
                    size: 60.sp,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      isDismissible: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: DraggableScrollableSheet(
                            maxChildSize: .5,
                            initialChildSize: .5,
                            minChildSize: 0.2,
                            builder: (context, scrollController) =>
                                ImagePickerGrid(
                              onImageCaptured: _onImageCaptured,
                              onImageToggle: _onImageToggle,
                              selectedFiles: selectedFiles,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

                // Send button
                IconButton(
                  icon: Icon(
                    Icons.send_rounded,
                    color: AppColors.background,
                    size: 60.sp,
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
