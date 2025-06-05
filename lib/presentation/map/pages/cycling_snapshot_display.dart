import 'dart:io';
import 'package:Tracio/common/widget/navbar/bottom_nav_bar_manager.dart';
import 'package:Tracio/data/auth/sources/auth_local_source/auth_local_source.dart';
import 'package:Tracio/data/map/models/request/post_route_media_req.dart';
import 'package:Tracio/data/map/models/request/update_route_req.dart';
import 'package:Tracio/presentation/library/pages/route_detail.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:Tracio/presentation/map/bloc/tracking/bloc/tracking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Tracio/domain/map/entities/route.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Tracio/presentation/map/widgets/mood_selector.dart';

class CyclingSnapshotDisplay extends StatefulWidget {
  final RouteEntity route;

  const CyclingSnapshotDisplay({
    super.key,
    required this.route,
  });

  @override
  State<CyclingSnapshotDisplay> createState() => _CyclingSnapshotDisplayState();
}

class _CyclingSnapshotDisplayState extends State<CyclingSnapshotDisplay> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final List<XFile> _selectedImages = [];
  RouteMood? _chosenMood;
  bool _isPublic = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.route.routeName);
    _descriptionController =
        TextEditingController(text: widget.route.description ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 3) return;
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  void _submit() {
    final name = _nameController.text.trim();
    final desc = _descriptionController.text.trim();
    final updateRequest = UpdateRouteReq(
      routeId: widget.route.routeId,
      routeName: name,
      description: desc,
      routeThumbnail: context.read<MapCubit>().snapshotImageUrl.toString(),
      isPublic: _isPublic,
      mood: _chosenMood?.name ?? "None",
    );
    final List<PostRouteMediaReq> routeMedias = _selectedImages
        .map(
          (image) => PostRouteMediaReq(
            routeId: widget.route.routeId,
            mediaFile: File(image.path),
          ),
        )
        .toList();
    final rootContext = context;
    showDialog(
      context: rootContext,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<MapCubit>(),
        child: BlocProvider.value(
          value: context.read<RouteCubit>(),
          child: BlocConsumer<RouteCubit, RouteState>(
            listener: (context, state) async {
              if (state is UpdateRouteLoaded) {
                if (Navigator.canPop(rootContext)) {
                  Navigator.of(rootContext).pop();
                }
                if (!mounted) return;
                FocusScope.of(context).unfocus();

                final result = await Navigator.of(rootContext).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<MapCubit>(),
                      child: BlocProvider.value(
                        value: context.read<RouteCubit>()
                          ..getRouteDetail(widget.route.routeId),
                        child: RouteDetailScreen(routeId: widget.route.routeId),
                      ),
                    ),
                  ),
                );
                if (result == true) {
                  if (Navigator.canPop(rootContext)) {
                    Navigator.of(rootContext).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => BottomNavBarManager(
                          selectedIndex: 0,
                          isNavVisible: true,
                        ),
                      ),
                    );
                  }
                }
              } else if (state is UpdateRouteFailure) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
            },
            builder: (context, state) {
              if (state is UpdateRouteLoadingProgress) {
                return AlertDialog(
                  title: const Text("Uploading"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LinearProgressIndicator(value: state.progress),
                      SizedBox(height: 12),
                      Text(state.statusMessage),
                    ],
                  ),
                );
              } else {
                return const AlertDialog(
                  content: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 16),
                        Expanded(child: Text("Saving route..."))
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );

    context.read<RouteCubit>().updateRouteWithMedia(updateRequest, routeMedias);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        FocusScope.of(context).unfocus();
        final navigator = Navigator.of(context);
        final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Discard Changes?'),
            content: const Text(
                'You have unsaved changes. Are you sure you want to leave?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Leave')),
            ],
          ),
        );
        if (shouldLeave != null && shouldLeave) {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Save Route")),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 100.h),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Image section
                            BlocBuilder<MapCubit, MapCubitState>(
                              builder: (context, state) {
                                if (state is StaticImageLoaded) {
                                  return CachedNetworkImage(
                                    imageUrl: state.snapshot.toString(),
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    height: 180.h,
                                    placeholder: (_, __) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (_, __, ___) =>
                                        const Icon(Icons.error),
                                  );
                                } else {
                                  return _buildGreyBackgroundImage(
                                      height: 180.h);
                                }
                              },
                            ),

                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    controller: _nameController,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Route Name",
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade300)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade400),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  TextField(
                                    controller: _descriptionController,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      labelText: "Description",
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade300)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade400),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Make route public:",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Switch(
                                        value: _isPublic,
                                        onChanged: (value) {
                                          setState(() {
                                            _isPublic = value;
                                          });
                                        },
                                        activeColor: Colors.green,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Text("Photos (max 3):",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      ..._selectedImages.map((x) => Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                Image.file(File(x.path),
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.cover),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedImages.remove(x);
                                                    });
                                                  },
                                                  child: const Icon(
                                                      Icons.cancel,
                                                      size: 20,
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                          )),
                                      if (_selectedImages.length < 3)
                                        GestureDetector(
                                          onTap: _pickImage,
                                          child: Container(
                                            width: 70,
                                            height: 70,
                                            color: Colors.grey.shade300,
                                            child:
                                                const Icon(Icons.add_a_photo),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Text("Select your feeling:",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8.h),
                                  MoodSelector(
                                    onChanged: (mood) {
                                      setState(() {
                                        _chosenMood = mood;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 32.h),
                                  InkWell(
                                    onTap: () async {
                                      final shouldDelete =
                                          await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Confirm Delete"),
                                          content: const Text(
                                              "Are you sure you want to delete this item?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text("Delete",
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (shouldDelete == true) {
                                        context
                                            .read<RouteCubit>()
                                            .deleteRoute(widget.route.routeId);
                                      }
                                    },
                                    child: Ink(
                                      width: double.infinity,
                                      height: 60.h,
                                      color: Colors.grey.shade200,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.delete,
                                                color: Colors.redAccent),
                                            SizedBox(width: 8.h),
                                            const Text("Delete",
                                                style: TextStyle(
                                                    color: Colors.redAccent)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 80.h),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Fixed Save Button
                  Positioned(
                    bottom: 16.h,
                    left: 16.w,
                    right: 16.w,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 6.0,
                            spreadRadius: .5,
                            offset: const Offset(0, -5))
                      ]),
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        child: const Text("Save",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  BlocConsumer<RouteCubit, RouteState>(
                    listener: (context, state) {
                      if (state is DeleteRouteSuccess) {
                        // Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Deleted successfully"),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => MapCubit(),
                                  child: const BottomNavBarManager(
                                    selectedIndex: 1,
                                    isNavVisible: false,
                                  ),
                                ),
                              ),
                              (route) => false,
                            );
                          },
                        );
                      } else if (state is DeleteRouteFailure) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is DeleteRouteLoading;
                      if (!isLoading) return const SizedBox.shrink();

                      return Stack(
                        children: const [
                          Opacity(
                            opacity: 0.6,
                            child: ModalBarrier(
                                dismissible: false, color: Colors.black),
                          ),
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGreyBackgroundImage({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey.shade500,
      child: Image.asset(
        "assets/images/abstract-terrain-map.png",
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(0.5),
      ),
    );
  }
}
