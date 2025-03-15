import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/blog/pages/add_title_blog.dart';

import '../../../common/widget/blog/pick_image.dart';

class CreateBlogPage extends StatefulWidget {
  const CreateBlogPage({super.key});

  @override
  State<CreateBlogPage> createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  final List<File> selectedFiles = []; // Danh sách chứa các ảnh đã chọn

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // _fetchNewMedia();
    _pageController = PageController();
  }

  /// Hàm chọn hoặc bỏ chọn ảnh
  void _onImageToggle(File file, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedFiles.add(file); // Thêm vào danh sách chọn
      } else {
        selectedFiles.remove(file); // Bỏ chọn
      }
    });
  }

  void _onImageCaptured(File file) {
    setState(() {
      selectedFiles.add(file); // Thêm vào danh sách chọn
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
      if (selectedFiles.isEmpty) {
        // Nếu không còn ảnh nào
      } else if (index >= selectedFiles.length) {
        // Nếu xóa ảnh cuối cùng, chuyển về ảnh trước đó
        _pageController.jumpToPage(selectedFiles.length - 1);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'New Post',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddTitleBlogPage(
                        file: selectedFiles, // Truyền danh sách ảnh đã chọn
                      ),
                    ),
                  );
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                      fontSize: AppSize.textExtraLarge.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Hiển thị danh sách ảnh đã chọn
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: SelectedImagesViewer(
                selectedFiles: selectedFiles,
                onRemoveImage: _onRemoveImage,
                pageController: _pageController,
              ),
            ),
            // Tiêu đề 'Recent'
            Container(
              width: double.infinity,
              height: 20.h,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                'Recent',
                style: TextStyle(
                    fontSize: AppSize.textLarge.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),

            Expanded(
                child: ImagePickerGrid(
                    selectedFiles: selectedFiles,
                    onImageToggle: _onImageToggle,
                    onImageCaptured: _onImageCaptured)),
          ],
        ),
      ),
    );
  }
}
