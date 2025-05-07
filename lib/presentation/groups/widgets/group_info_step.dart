// ignore_for_file: use_build_context_synchronously

import 'dart:io'; // For the File class
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/groups/cubit/form_group_cubit.dart';

class GroupInfoStep extends StatefulWidget {
  const GroupInfoStep({super.key});

  @override
  State<GroupInfoStep> createState() => _GroupInfoStepState();
}

class _GroupInfoStepState extends State<GroupInfoStep> {
  final _groupNameController = TextEditingController();
  final _groupDescriptionController = TextEditingController();

  final _groupNameFocusNode = FocusNode();
  final _groupDescriptionFocusNode = FocusNode();

  String? _imagePath;
  int _maxParticipants = 10;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing state
    final groupReq = context.read<FormGroupCubit>().state.groupRequest;
    _groupNameController.text = groupReq.groupName;
    _groupDescriptionController.text = groupReq.description;
    _imagePath = groupReq.groupThumbnail?.path;
    _maxParticipants = groupReq.maxParticipants;

    // Listeners
    _groupNameController.addListener(() {
      context.read<FormGroupCubit>().updateGroupName(_groupNameController.text);
      context.read<FormGroupCubit>().validateStep(0);
    });
    _groupDescriptionController.addListener(() {
      context
          .read<FormGroupCubit>()
          .updateDescription(_groupDescriptionController.text);
      context.read<FormGroupCubit>().validateStep(0);
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
      context.read<FormGroupCubit>().updateGroupThumbnail(File(image.path));
      print(File(image.path));
      context.read<FormGroupCubit>().validateStep(0);
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _groupDescriptionController.dispose();
    _groupNameFocusNode.dispose();
    _groupDescriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _groupNameFocusNode.unfocus();
        _groupDescriptionFocusNode.unfocus();
      },
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customize Your Group",
              style: TextStyle(
                fontSize: AppSize.textHeading.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Choose a group name, ~ a photo, and write a description. "
              "You can always edit these later.",
              style: TextStyle(
                fontSize: AppSize.textSmall.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: AppSize.apVerticalPadding),

            // Choose Image
            Center(
                child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imagePath == null
                    ? Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.grey[600],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_imagePath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return const Center(
                                child:
                                    Text('This image type is not supported'));
                          },
                        ),
                      ),
              ),
            )),
            SizedBox(height: AppSize.apVerticalPadding),

            // Group Name
            TextField(
              scrollPadding: EdgeInsets.only(bottom: keyboardHeight),
              controller: _groupNameController,
              focusNode: _groupNameFocusNode,
              decoration: InputDecoration(
                labelText: "Group Name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey[600]!,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSize.apVerticalPadding),

            // Group Description
            TextField(
              scrollPadding: EdgeInsets.only(bottom: keyboardHeight),
              controller: _groupDescriptionController,
              focusNode: _groupDescriptionFocusNode,
              maxLines: 5,
              maxLength: 200,
              decoration: InputDecoration(
                labelText: "Group Description",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade600,
                    width: 2,
                  ),
                ),
                counterText: '${_groupDescriptionController.text.length}/200',
              ),
            ),
            // Max Participants
            Row(
              children: [
                Text(
                  "Max Participants:",
                  style: TextStyle(fontSize: AppSize.textMedium.sp),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButton<int>(
                    isDense: true,
                    menuMaxHeight: 200.h,
                    value: _maxParticipants,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _maxParticipants = value;
                        });
                        context
                            .read<FormGroupCubit>()
                            .updateMaxParticipants(value);
                        context.read<FormGroupCubit>().validateStep(0);
                      }
                    },
                    items: List.generate(30, (index) => index + 1)
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text('$e'),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.apVerticalPadding),
            Divider(color: Colors.grey.shade400),
            Align(
              alignment: Alignment.center,
              child: Text(
                "You can always change this later",
                style: TextStyle(
                  fontSize: AppSize.textSmall.sp,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: AppSize.apVerticalPadding),
          ],
        ),
      ),
    );
  }
}
