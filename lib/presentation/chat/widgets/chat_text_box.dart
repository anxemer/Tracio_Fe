import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/map/models/request/get_route_req.dart';
import 'package:Tracio/domain/map/entities/route.dart';
import 'package:Tracio/presentation/chat/bloc/bloc/conversation_bloc.dart';
import 'package:Tracio/presentation/library/pages/library.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as im;

class ChatTextBox extends StatefulWidget {
  final TextEditingController textEditingController;
  final void Function(ChatLoaded state, XFile? file, int? routeId) onSent;
  const ChatTextBox(
      {super.key, required this.textEditingController, required this.onSent});

  @override
  State<ChatTextBox> createState() => _ChatTextBoxState();
}

class _ChatTextBoxState extends State<ChatTextBox> {
  bool isTyping = false;
  bool isRouteSelected = false;
  bool isImageSelected = false;
  final ImagePicker imagePicker = ImagePicker();
  XFile? imageFile;
  double imagePickerHeight = 100.h;
  RouteEntity? selectedRoute;

  void selectImages() async {
    FocusScope.of(context).unfocus();

    final XFile? selectedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (selectedImage != null) {
      final File? compressedFile =
          await compressImage(File(selectedImage.path));
      if (compressedFile != null) {
        setState(() {
          imageFile = XFile(compressedFile.path);
          isRouteSelected = false;
          isImageSelected = false;
        });
      }
    }
  }

  Future<File?> compressImage(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final imageId = const Uuid().v4();
      final targetPath = '${tempDir.path}/img_$imageId.jpg';

      final rawBytes = await file.readAsBytes();
      final decodedImage = im.decodeImage(rawBytes);
      if (decodedImage == null) return null;

      final compressedBytes = im.encodeJpg(decodedImage, quality: 80);
      final compressedFile =
          await File(targetPath).writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      debugPrint('Compression failed: $e');
      return null;
    }
  }

  void selectRoute() async {
    FocusScope.of(context).unfocus();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: context.read<RouteCubit>()
                    ..getRoutes(GetRouteReq(pageSize: 10, pageNumber: 1)),
                  child: LibraryPage(),
                )));
    setState(() {
      isRouteSelected = false;
      isImageSelected = false;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.textEditingController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onSent() {
    final routeId = selectedRoute?.routeId;
    final state = context.read<ConversationBloc>().state;

    if (state is ChatLoaded) {
      widget.onSent(state, imageFile, routeId);
      setState(() {
        widget.textEditingController.clear();
        imageFile = null;
        isRouteSelected = false;
        isImageSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Divider(
            height: 1,
            color: Colors.grey.shade300,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (imageFile != null)
                  SizedBox(
                    height: 90.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      separatorBuilder: (_, __) => SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return _removable(
                            context,
                            _imageView(
                              context,
                              Image.file(
                                File(imageFile!.path),
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                              index,
                            ),
                            index);
                      },
                    ),
                  ),
                Row(
                  children: [
                    IconButton(
                      tooltip: "Share route",
                      isSelected: isRouteSelected && !isImageSelected,
                      icon: Icon(Icons.route),
                      color: isImageSelected
                          ? Colors.grey.shade600
                          : AppColors.primary,
                      selectedIcon: Icon(Icons.route, color: AppColors.primary),
                      onPressed: () {
                        setState(() {
                          if (isRouteSelected) {
                            isRouteSelected = false;
                            isImageSelected = false;
                          } else {
                            isRouteSelected = true;
                            isImageSelected = false;

                            selectRoute();
                          }
                        });
                      },
                    ),
                    IconButton(
                      tooltip: "Choose Image",
                      icon: Icon(Icons.image),
                      color: isRouteSelected
                          ? Colors.grey.shade600
                          : AppColors.primary,
                      isSelected: isImageSelected && !isRouteSelected,
                      selectedIcon: Icon(Icons.image, color: AppColors.primary),
                      onPressed: () {
                        setState(() {
                          if (isImageSelected) {
                            isRouteSelected = false;
                            isImageSelected = false;
                          } else {
                            isRouteSelected = false;
                            isImageSelected = true;
                            selectImages();
                          }
                        });
                      },
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(40)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: widget.textEditingController,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  hintText: "Message",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                ),
                                minLines: 1,
                                maxLines: 3,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color:
                                    widget.textEditingController.text.isNotEmpty
                                        ? AppColors.primary
                                        : Colors.grey,
                              ),
                              onPressed: _onSent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _removable(BuildContext context, Widget child, int index) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        child,
        Positioned(
            top: 4,
            right: 10.w,
            child: Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(Icons.clear,
                    size: AppSize.iconSmall * 0.8.w, color: Colors.red),
                onPressed: () {
                  setState(() {
                    imageFile = null;
                  });
                },
              ),
            )),
      ],
    );
  }

  Widget _imageView(BuildContext context, Widget image, [int? index]) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: image,
      ),
    );
  }
}
