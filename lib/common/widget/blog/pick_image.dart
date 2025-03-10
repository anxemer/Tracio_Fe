import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

/// Widget hiển thị lưới ảnh từ thư viện và cho phép chụp ảnh
class ImagePickerGrid extends StatefulWidget {
  /// Danh sách ảnh đã chọn
  final List<File> selectedFiles;

  /// Callback được gọi khi chọn/bỏ chọn ảnh
  final Function(File file, bool isSelected) onImageToggle;

  /// Callback được gọi khi chụp ảnh mới
  final Function(File file) onImageCaptured;

  /// Số cột trong lưới
  final int crossAxisCount;

  /// Số lượng ảnh tải mỗi lần
  final int pageSize;

  const ImagePickerGrid({
    Key? key,
    required this.selectedFiles,
    required this.onImageToggle,
    required this.onImageCaptured,
    this.crossAxisCount = 3,
    this.pageSize = 60,
  }) : super(key: key);

  @override
  State<ImagePickerGrid> createState() => _ImagePickerGridState();
}

class _ImagePickerGridState extends State<ImagePickerGrid> {
  final List<Widget> _mediaList = [];
  final List<File> allFiles = []; // Lưu tất cả ảnh từ album
  int currentPage = 0;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  /// Lấy danh sách ảnh từ album
  Future<void> _fetchNewMedia() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps.isAuth) {
        List<AssetPathEntity> album =
            await PhotoManager.getAssetPathList(type: RequestType.image);

        if (album.isEmpty) {
          setState(() {
            _hasMore = false;
            _isLoading = false;
          });
          return;
        }

        List<AssetEntity> media = await album[0]
            .getAssetListPaged(page: currentPage, size: widget.pageSize);

        if (media.isEmpty) {
          setState(() {
            _hasMore = false;
            _isLoading = false;
          });
          return;
        }

        for (var asset in media) {
          if (asset.type == AssetType.image) {
            final file = await asset.file;
            if (file != null) {
              allFiles.add(File(file.path)); // Lưu ảnh vào danh sách tổng
            }
          }
        }

        List<Widget> temp = [];

        // Thêm ô chụp ảnh vào vị trí đầu tiên nếu đang ở trang đầu
        if (currentPage == 0) {
          temp.add(
            GestureDetector(
              onTap: _takePicture,
              child: Container(
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 80.w,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }

        // Thêm các ảnh từ thư viện
        temp.addAll(media.map((asset) {
          return FutureBuilder(
            future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                );
              }
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        }).toList());

        setState(() {
          _mediaList.addAll(temp);
          currentPage++;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Lỗi khi tải ảnh: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Hàm mở máy ảnh và chụp ảnh
  Future<void> _takePicture() async {
    try {
      final XFile? photo =
          await _imagePicker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        File imageFile = File(photo.path);

        // Thêm ảnh vào danh sách tổng
        setState(() {
          allFiles.insert(0, imageFile);

          // Thêm ảnh vào đầu danh sách hiển thị (sau ô camera)
          _mediaList.insert(
              1,
              Image.file(
                imageFile,
                fit: BoxFit.cover,
              ));
        });

        // Gọi callback
        widget.onImageCaptured(imageFile);
      }
    } catch (e) {
      print('Lỗi khi chụp ảnh: $e');
    }
  }

  /// Hàm chọn hoặc bỏ chọn ảnh
  void _toggleSelection(int index) {
    // Điều chỉnh index vì có ô camera ở đầu
    if (index == 0) {
      // Nếu nhấn vào ô camera thì mở camera
      _takePicture();
      return;
    }

    int adjustedIndex = index - 1;
    if (adjustedIndex >= 0 && adjustedIndex < allFiles.length) {
      File selectedFile = allFiles[adjustedIndex];
      bool isCurrentlySelected = widget.selectedFiles.contains(selectedFile);

      // Gọi callback
      widget.onImageToggle(selectedFile, !isCurrentlySelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _fetchNewMedia();
        }
        return true;
      },
      child: GridView.builder(
        itemCount: _mediaList.length + (_isLoading ? 1 : 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          mainAxisSpacing: 1,
          crossAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          // Hiển thị loading indicator
          if (index >= _mediaList.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Nếu là ô đầu tiên (camera)
          if (index == 0) {
            return _mediaList[index];
          }

          // Điều chỉnh index cho các ảnh
          int fileIndex = index - 1;
          bool isSelected = fileIndex < allFiles.length &&
              widget.selectedFiles.contains(allFiles[fileIndex]);

          return GestureDetector(
            onTap: () => _toggleSelection(index),
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
    );
  }
}

/// Widget hiển thị ảnh đã chọn dưới dạng PageView
class SelectedImagesViewer extends StatefulWidget {
  /// Danh sách ảnh đã chọn
  final List<File> selectedFiles;

  /// Callback được gọi khi xóa ảnh
  final Function(int index) onRemoveImage;

  /// Controller cho PageView
  final PageController pageController;

  /// Callback được gọi khi thay đổi trang
  final Function(int page)? onPageChanged;
  final double? widgeImage;
  const SelectedImagesViewer({
    Key? key,
    required this.selectedFiles,
    required this.onRemoveImage,
    required this.pageController,
    this.onPageChanged,
    this.widgeImage,
  }) : super(key: key);

  @override
  State<SelectedImagesViewer> createState() => _SelectedImagesViewerState();
}

class _SelectedImagesViewerState extends State<SelectedImagesViewer> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return widget.selectedFiles.isEmpty
        ? Center(child: Text('Chọn ảnh để hiển thị'))
        : PageView.builder(
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
              if (widget.onPageChanged != null) {
                widget.onPageChanged!(value);
              }
            },
            controller: widget.pageController,
            itemCount: widget.selectedFiles.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.h),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Image.file(
                      widget.selectedFiles[index],
                      width: widget.widgeImage ?? 600.w,
                      fit: BoxFit.cover,
                    ),
                    GestureDetector(
                      onTap: () => widget.onRemoveImage(index),
                      child: Container(
                        margin: EdgeInsets.all(5.w),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 32.w,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            List.generate(widget.selectedFiles.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 32.w : 16.w,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              );
            });
  }
}

/// Hàm tiện ích để mở ImagePicker
class ImagePickerUtils {
  static final ImagePicker _picker = ImagePicker();

  /// Chụp ảnh từ camera
  static Future<File?> takePhoto({
    ImageQuality quality = ImageQuality.high,
  }) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: quality == ImageQuality.high
            ? 100
            : quality == ImageQuality.medium
                ? 70
                : 40,
      );

      if (photo != null) {
        return File(photo.path);
      }
    } catch (e) {
      print('Lỗi khi chụp ảnh: $e');
    }
    return null;
  }

  /// Chọn ảnh từ thư viện
  static Future<File?> pickImage({
    ImageQuality quality = ImageQuality.high,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: quality == ImageQuality.high
            ? 100
            : quality == ImageQuality.medium
                ? 70
                : 40,
      );

      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      print('Lỗi khi chọn ảnh: $e');
    }
    return null;
  }

  /// Chọn nhiều ảnh từ thư viện
  static Future<List<File>> pickMultiImage({
    ImageQuality quality = ImageQuality.high,
  }) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: quality == ImageQuality.high
            ? 100
            : quality == ImageQuality.medium
                ? 70
                : 40,
      );

      return images.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      print('Lỗi khi chọn nhiều ảnh: $e');
      return [];
    }
  }
}

/// Chất lượng ảnh khi chụp/chọn
enum ImageQuality {
  low,
  medium,
  high,
}
