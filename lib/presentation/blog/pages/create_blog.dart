import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tracio_fe/presentation/blog/bloc/create_blog_cubit.dart';
import 'package:tracio_fe/presentation/blog/pages/add_title_blog.dart';

class CreateBlogPage extends StatefulWidget {
  const CreateBlogPage({super.key});

  @override
  State<CreateBlogPage> createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  final List<Widget> _mediaList = [];
  final List<File> selectedFiles = []; // Danh sách chứa các ảnh đã chọn
  final List<File> allFiles = []; // Lưu tất cả ảnh từ album
  int currentPage = 0;
  int _currentPage = 0;
  int? lastPage;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
    _pageController = PageController();
  }

  /// Lấy danh sách ảnh từ album
  _fetchNewMedia() async {
    lastPage = currentPage;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(type: RequestType.image);
      List<AssetEntity> media =
          await album[0].getAssetListPaged(page: currentPage, size: 60);

      for (var asset in media) {
        if (asset.type == AssetType.image) {
          final file = await asset.file;
          if (file != null) {
            allFiles.add(File(file.path)); // Lưu ảnh vào danh sách tổng
          }
        }
      }

      List<Widget> temp = media.map((asset) {
        return FutureBuilder(
          future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              );
            }
            return Container();
          },
        );
      }).toList();

      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    }
  }

  /// Hàm chọn hoặc bỏ chọn ảnh
  void toggleSelection(int index) {
    setState(() {
      File selectedFile = allFiles[index];
      if (selectedFiles.contains(selectedFile)) {
        selectedFiles.remove(selectedFile); // Bỏ chọn nếu đã có
      } else {
        selectedFiles.add(selectedFile); // Thêm vào danh sách chọn
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
                  style: TextStyle(fontSize: 40.sp, color: Colors.blue),
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
                child: selectedFiles.isEmpty
                    ? Center(child: Text('Chọn ảnh để hiển thị'))
                    : PageView.builder(
                        onPageChanged: (value) => setState(() {
                              _currentPage = value;
                            }),
                        controller: _pageController,
                        itemCount: selectedFiles.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 80.h),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Image.file(
                                  selectedFiles[index],
                                  width: 600.w,
                                  // height: 300,
                                  fit: BoxFit.fill,
                                ),
                                GestureDetector(
                                  onTap: () => toggleSelection(index),
                                  child: Container(
                                    margin: EdgeInsets.all(5.w),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 24.w,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                        selectedFiles.length, (index) {
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        width:
                                            _currentPage == index ? 32.w : 16.w,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: _currentPage == index
                                              ? Colors.white
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      );
                                    }),
                                  ),
                                )
                              ],
                            ),
                          );
                        })),

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
              child: GridView.builder(
                itemCount: _mediaList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  bool isSelected = selectedFiles.contains(allFiles[index]);
                  return GestureDetector(
                    onTap: () => toggleSelection(index),
                    child: Stack(
                      children: [
                        Positioned.fill(child: _mediaList[index]),
                        if (isSelected)
                          Container(
                            color: Colors.black54,
                            child: Center(
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 40.w,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
