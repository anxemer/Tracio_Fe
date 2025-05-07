import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/blog/pages/add_title_blog.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/widget/blog/pick_image.dart';
import '../../../common/widget/button/button.dart';
import '../../../core/configs/theme/assets/app_images.dart';

class CreateBlogPage extends StatefulWidget {
  const CreateBlogPage({super.key});

  @override
  State<CreateBlogPage> createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  final List<File> selectedFiles = []; // Danh sách chứa các ảnh đã chọn
  List<File> _selectedImageFiles = [];

  final ImagePicker _picker = ImagePicker();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // _fetchNewMedia();
    _pageController = PageController();
  }

  Future<void> _pickImages(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> pickedFiles = await _picker.pickMultiImage(
          maxWidth: 1024,
          imageQuality: 85,
        );

        if (pickedFiles.isNotEmpty) {
          setState(() {
            selectedFiles.addAll(pickedFiles.map((file) => File(file.path)));
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

  /// Hàm chọn hoặc bỏ chọn ảnh
  // void _onImageToggle(File file, bool isSelected) {
  //   setState(() {
  //     if (isSelected) {
  //       selectedFiles.add(file); // Thêm vào danh sách chọn
  //     } else {
  //       selectedFiles.remove(file); // Bỏ chọn
  //     }
  //   });
  // }

  // void _onImageCaptured(File file) {
  //   setState(() {
  //     selectedFiles.add(file); // Thêm vào danh sách chọn
  //   });
  //   _pageController.animateToPage(
  //     selectedFiles.length - 1,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

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
            Expanded(
              child: SizedBox(
                // height: MediaQuery.of(context).size.height / 2,
                child: SelectedImagesViewer(
                  selectedFiles: selectedFiles,
                  onRemoveImage: _onRemoveImage,
                  pageController: _pageController,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSize.apHorizontalPadding,
                  vertical: AppSize.apVerticalPadding),
              child: ButtonDesign(
                ontap: () {
                  _showImageSourceDialog();
                },
                fillColor: Colors.grey.shade500,
                borderColor: Colors.grey.shade600,
                text: 'Add picture',
                icon: Icon(Icons.image_search),
                textColor: Colors.white,
                iconSize: AppSize.iconLarge,
                width: 160.w,
                fontSize: AppSize.textLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
