import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tracio_fe/presentation/blog/bloc/create_blog_cubit.dart';
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

  // /// Lấy danh sách ảnh từ album
  // _fetchNewMedia() async {
  //   lastPage = currentPage;
  //   final PermissionState ps = await PhotoManager.requestPermissionExtend();
  //   if (ps.isAuth) {
  //     List<AssetPathEntity> album =
  //         await PhotoManager.getAssetPathList(type: RequestType.image);
  //     List<AssetEntity> media =
  //         await album[0].getAssetListPaged(page: currentPage, size: 60);

  //     for (var asset in media) {
  //       if (asset.type == AssetType.image) {
  //         final file = await asset.file;
  //         if (file != null) {
  //           allFiles.add(File(file.path)); // Lưu ảnh vào danh sách tổng
  //         }
  //       }
  //     }

  //     List<Widget> temp = [];

  //     if (currentPage == 0) {
  //       temp.add(GestureDetector(
  //         onTap: _takePicture,
  //         child: Container(
  //           color: Colors.grey.shade400,
  //           child: Center(
  //             child: Icon(
  //               Icons.camera_alt_outlined,
  //               size: 80.w,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ));
  //     }
  //     temp.addAll(media.map((asset) {
  //       return FutureBuilder(
  //         future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.done) {
  //             return Image.memory(
  //               snapshot.data!,
  //               fit: BoxFit.cover,
  //             );
  //           }
  //           return Container();
  //         },
  //       );
  //     }).toList());

  //     setState(() {
  //       _mediaList.addAll(temp);
  //       currentPage++;
  //     });
  //   }
  // }

  // Future<void> _takePicture() async {
  //   try {
  //     final XFile? photo =
  //         await _imagePicker.pickImage(source: ImageSource.camera);
  //     if (photo != null) {
  //       File imageFile = File(photo.path);
  //       setState(() {
  //         // Thêm ảnh vào danh sách tổng
  //         // allFiles.insert(0, imageFile);

  //         // Thêm vào danh sách đã chọn
  //         selectedFiles.add(imageFile);

  //         // Thêm ảnh vào đầu danh sách hiển thị
  //         // _mediaList.insert(
  //         //     1,
  //         //     Image.file(
  //         //       imageFile,
  //         //       fit: BoxFit.cover,
  //         //     ));
  //       });

  //       // Cập nhật PageView để hiển thị ảnh vừa chụp
  //       _pageController.animateToPage(
  //         selectedFiles.length,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   } catch (e) {
  //     print('Lỗi khi chụp ảnh: $e');
  //   }
  // }

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
  //   if (adjustedIndex >= 0 && adjustedIndex < allFiles.length) {
  //     setState(() {
  //       File selectedFile = allFiles[adjustedIndex];
  //       if (selectedFiles.contains(selectedFile)) {
  //         selectedFiles.remove(selectedFile); // Bỏ chọn nếu đã có
  //       } else {
  //         selectedFiles.add(selectedFile); // Thêm vào danh sách chọn
  //       }
  //     });
  //   }
  // }

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
                  if (selectedFiles.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddTitleBlogPage(
                          file: selectedFiles, // Truyền danh sách ảnh đã chọn
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                      fontSize: 32.sp,
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
              height: 60.h,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Recent',
                style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w600),
              ),
            ),

            // GridView hiển thị tất cả ảnh
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
