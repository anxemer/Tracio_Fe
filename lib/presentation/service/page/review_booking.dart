import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/shop/models/review_booking_req.dart';
import 'package:tracio_fe/presentation/service/bloc/review_booking/cubit/review_booking_cubit.dart';

class ReviewBookingScreen extends StatefulWidget {
  const ReviewBookingScreen({
    super.key,
    required this.imageUrl,
    required this.serviceName,
    required this.bookingId,
  });
  final String imageUrl;
  final String serviceName;
  final int bookingId;

  @override
  State<ReviewBookingScreen> createState() => _ReviewBookingScreenState();
}

class _ReviewBookingScreenState extends State<ReviewBookingScreen> {
  File? _pickedImageFile;
  final ImagePicker _picker = ImagePicker();
  final _reviewController = TextEditingController();
  double _rating = 3;
  // List<File> _selectedImages = []; // Uncomment if adding image picking logic
  // final ImagePicker _picker = ImagePicker(); // Uncomment if adding image picking logic
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800, // Giới hạn kích thước ảnh để tối ưu
        imageQuality: 85, // Giảm chất lượng ảnh một chút
      );

      if (pickedFile != null) {
        setState(() {
          _pickedImageFile = File(pickedFile.path);
// Xoá ảnh cũ nếu chọn ảnh mới
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Can\'t select photo')),
      );
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
                  _pickImage(ImageSource.gallery);
                  Navigator.of(ctx).pop();
                }),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a new photo'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  /* // Uncomment if adding image picking logic
  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage(
      maxWidth: 1024,
      imageQuality: 85,
    );

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }
  */

  void _submitReview() {
    final reviewText = _reviewController.text;
    final rating = _rating.toInt();
    final images = _pickedImageFile;

    print('Rating: $rating');
    print('Rating: ${widget.bookingId}');
    print('Review: $reviewText');
    // print('Images: ${images.map((f) => f.path).toList()}'); // Uncomment

    // TODO: Implement actual submission logic (e.g., API call)

    context.read<ReviewBookingCubit>().reviewBooking(ReviewBookingReq(
        bookingDetailId: widget.bookingId,
        content: reviewText,
        rating: rating,
        mediaFiles: [images!]));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review Submitted')),
    );
    // Maybe pop screen after successful submission
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocListener<ReviewBookingCubit, ReviewBookingState>(
        listener: (context, state) {
          if (state is ReviewBookingSuccess) {
            Navigator.pop(context);
          }
          if (state is ReviewBookingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                'Review Booking Fail! Please Try Again',
              )),
            );
          }
        },
        child: Scaffold(
          appBar: BasicAppbar(
            title: Text(
              'Write a review for',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: AppSize.textHeading,
                  fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            // scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                          width: AppSize.imageLarge.w * 2,
                          height: AppSize.imageLarge.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ));
                    },
                    placeholder: (context, url) =>
                        LoadingAnimationWidget.fourRotatingDots(
                      color: AppColors.secondBackground,
                      size: AppSize.iconExtraLarge,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  widget.serviceName,
                  style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                  unratedColor: Colors.grey[300],
                  glow: false,
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: _reviewController,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'What did you like or dislike?',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: colorScheme.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                Container(
                  width: AppSize.imageLarge.w,
                  height: AppSize.imageLarge.h,
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: .3),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.blue.shade300,
                      width: 1.5,
                    ),
                  ),
                  // Sử dụng ClipRRect để đảm bảo ảnh bên trong cũng được bo góc
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap:
                        _showImageSourceDialog, // Nhấn vào sẽ luôn mở chọn ảnh
                    child: _pickedImageFile == null
                        // Nếu chưa có ảnh nào được chọn -> Hiển thị placeholder
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_outlined,
                                  color: colorScheme.primary,
                                  size: AppSize.iconLarge),
                              const SizedBox(height: 8),
                              Text(
                                'Add a photo',
                                style: TextStyle(color: colorScheme.primary),
                              ),
                            ],
                          )
                        // Nếu ĐÃ CÓ ảnh được chọn -> Hiển thị ảnh đó
                        : Image.file(
                            _pickedImageFile!,
                            fit: BoxFit.fill,
                            // width: double.infinity,
                            // height: 400.h,
                          ),
                  ),
                ),
                // --- End Change ---

                // TODO: Display selected images here if implementing image picking

                const SizedBox(height: 30.0),
              ],
            ),
          ),
          bottomNavigationBar:
              BlocBuilder<ReviewBookingCubit, ReviewBookingState>(
            builder: (context, state) {
              if (state is ReviewBookingLoading) {
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: AppColors.secondBackground,
                    size: AppSize.iconExtraLarge,
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    textStyle: TextStyle(
                        fontSize: AppSize.textLarge,
                        fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Submit'),
                ),
              );
            },
          ),
        ));
  }
}
