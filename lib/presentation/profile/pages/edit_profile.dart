import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracio_fe/common/widget/button/button.dart';

import 'package:tracio_fe/common/widget/input_text_form_field.dart';
import 'package:tracio_fe/common/widget/picture/circle_picture.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/user/entities/user_profile_entity.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});
  final UserProfileEntity user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  final TextEditingController _cityCon = TextEditingController();
  final TextEditingController _stateCon = TextEditingController();
  final TextEditingController _bioCon = TextEditingController();
  final TextEditingController _genderCon = TextEditingController();
  final TextEditingController _heightCon = TextEditingController();
  final TextEditingController _weightCon = TextEditingController();
  final TextEditingController _birthdatCon = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Future<void> _getImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // height: MediaQuery.of(context).size.height / 2,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _imageFile == null
                        ? CirclePicture(
                            imageUrl: widget.user.profilePicture!,
                            imageSize: AppSize.imageMedium)
                        : ClipOval(
                            child: SizedBox(
                              child: Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                                width: AppSize.imageExtraLarge.w,
                                height: AppSize.imageExtraLarge.h,
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 80.h,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CirclePicture(
                                imageUrl: AppImages.man,
                                imageSize: AppSize.iconMedium);
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 15),
                          itemCount: 8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonDesign(
                          ontap: () {
                            _getImageFromGallery();
                          },
                          fillColor: Colors.grey.shade500,
                          borderColor: Colors.grey.shade600,
                          text: 'Gallery',
                          image: AppImages.gallery,
                          textColor: Colors.white,
                          iconSize: AppSize.iconLarge,
                          width: 160.w,
                          fontSize: AppSize.textLarge,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        ButtonDesign(
                          ontap: () {
                            _getImageFromCamera();
                          },
                          fillColor: Colors.grey.shade500,
                          borderColor: Colors.grey.shade600,
                          text: 'Camera',
                          icon: Icon(Icons.camera_alt_rounded),
                          textColor: Colors.white,
                          iconSize: AppSize.iconLarge,
                          width: 160.w,
                          fontSize: AppSize.textLarge,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: AppSize.formFieldHeight * 2 + 10,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: AppSize.formFieldHeight,
                              child: InputTextFormField(
                                controller: _firstNameCon,
                                hint: 'First Name',
                                labelText: 'First Name',
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: AppSize.formFieldHeight,
                              child: InputTextFormField(
                                controller: _lastNameCon,
                                hint: 'Last name',
                                labelText: 'Last name',
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: AppSize.formFieldHeight,
                              child: InputTextFormField(
                                controller: _cityCon,
                                hint: 'City',
                                labelText: 'City',
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: AppSize.formFieldHeight,
                              child: InputTextFormField(
                                controller: _stateCon,
                                hint: 'State',
                                labelText: 'State',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: InputTextFormField(
                        controller: _bioCon,
                        hint: 'Bio',
                        labelText: 'Bio',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    TextField(
                      controller: _genderCon,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Colors.grey.shade500,
                          ),
                          fillColor: Colors.transparent,
                          hintText: 'Gender',
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                    Container(
                      height: 1.h,
                      width: 400.w,
                      color: Colors.grey.shade400,
                    ),
                    TextField(
                      controller: _heightCon,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Colors.grey.shade500,
                          ),
                          fillColor: Colors.transparent,
                          hintText: 'Height',
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                    Container(
                      height: 1.h,
                      width: 400.w,
                      color: Colors.grey.shade400,
                    ),
                    TextField(
                      controller: _weightCon,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Colors.grey.shade500,
                          ),
                          fillColor: Colors.transparent,
                          hintText: 'Weight',
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                    Container(
                      height: 1.h,
                      width: 400.w,
                      color: Colors.grey.shade400,
                    ),
                    TextField(
                      controller: _birthdatCon,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Colors.grey.shade500,
                          ),
                          fillColor: Colors.transparent,
                          hintText: 'Birthday',
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                    Container(
                      height: 1.h,
                      width: 400.w,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Gender, height, weight and date of birth are used to calculate values like calories burned, optimal calorie intake, and heart rate ranges during exercises. You don’t have to provide this information, but the health recommendations you get will be more accurate if you do. ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppSize.textLarge,
                  color: Colors.grey.shade700,
                ),
              )
            ],
          ),
        ),
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ButtonDesign(
              ontap: () {
                Navigator.pop(context);
              },
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              borderColor: AppColors.secondBackground,

              text: 'Cancel',
              icon: Icon(
                Icons.cancel_outlined,
                size: AppSize.iconLarge,
              ),
              // image: AppImages.,
              textColor: AppColors.primary,
              width: 160.w,
              fontSize: AppSize.textLarge,
            ),
            SizedBox(
              width: 10.w,
            ),
            ButtonDesign(
              ontap: () {},
              fillColor: AppColors.background,
              borderColor: AppColors.secondBackground,

              text: 'Save',
              icon: Icon(
                Icons.save_outlined,
                size: AppSize.iconLarge,
              ),
              // image: AppImages.,
              textColor: Colors.white,
              width: 160.w,
              fontSize: AppSize.textLarge,
            ),
          ],
        ),
      ),
    );
  }
}
