import 'dart:io';

import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/button/loading.dart';
import 'package:Tracio/data/user/models/edit_user_profile_req.dart';
import 'package:Tracio/presentation/profile/bloc/user_profile_cubit.dart';
import 'package:Tracio/presentation/profile/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Tracio/common/widget/button/button.dart';

import 'package:Tracio/common/widget/input_text_form_field.dart';
import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/configs/theme/assets/app_images.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/user/entities/user_profile_entity.dart';

import '../bloc/user_profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});
  final UserProfileEntity user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _fullnameCon = TextEditingController();
  final TextEditingController _cityCon = TextEditingController();
  final TextEditingController _districtCon = TextEditingController();
  final TextEditingController _bioCon = TextEditingController();
  final TextEditingController _genderCon = TextEditingController();

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
  void initState() {
    _fullnameCon.text = widget.user.userName!;
    _bioCon.text = widget.user.bio!;
    _cityCon.text = widget.user.city!;
    _districtCon.text = widget.user.district!;
    _genderCon.text = widget.user.gender!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileLoaded) {
          Navigator.pop(context);
          // AppNavigator.push(context,
          //     UserProfilePage(myProfile: true, userId: widget.user.userId));
        }
        if (state is UserProileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Updatge profile fail! Please try again')),
          );
        }
      },
      child: Scaffold(
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
                        height: 10.h,
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
                        height: 8.h,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: AppSize.formFieldHeight,
                          child: InputTextFormField(
                            controller: _fullnameCon,
                            hint: 'Fullname',
                            labelText: 'Fullname',
                          )),
                      SizedBox(
                        width: double.infinity,
                        height: AppSize.formFieldHeight * 2 + 10,
                        child: Row(
                          spacing: 4.w,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: AppSize.formFieldHeight,
                              child: InputTextFormField(
                                controller: _cityCon,
                                hint: 'City',
                                labelText: 'City',
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: AppSize.formFieldHeight,
                              child: InputTextFormField(
                                controller: _districtCon,
                                hint: 'District',
                                labelText: 'District',
                              ),
                            ),
                          ],
                        ),
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
                      DropdownButtonFormField<String>(
                        value:
                            _genderCon.text.isNotEmpty ? _genderCon.text : null,
                        items: ['Male', 'Female'].map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _genderCon.text = value; // cập nhật controller
                          }
                        },
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
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                      Container(
                        height: 1.h,
                        width: 400.w,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
        bottomNavigationBar: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return LoadingButton();
            }
            return Padding(
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
                    ontap: () {
                      final EditUserProfileReq req = EditUserProfileReq(
                          userName: _fullnameCon.text,
                          gender: _genderCon.text,
                          bio: _bioCon.text,
                          city: _cityCon.text,
                          district: _districtCon.text
                          // các field khác...
                          );

                      final File? avatar = _imageFile;

                      context.read<UserProfileCubit>().updateUserProfile(
                            profileReq: req,
                            newAvatarFile: avatar,
                          );
                    },

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
            );
          },
        ),
      ),
    );
  }
}
