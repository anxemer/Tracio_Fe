import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/user/models/edit_user_profile_req.dart';
import 'package:Tracio/domain/user/entities/user_profile_entity.dart';
import 'package:Tracio/domain/user/usecase/edit_profile.dart';
import 'package:Tracio/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountPrivacyScreen extends StatefulWidget {
  const AccountPrivacyScreen(
      {super.key, required this.userId, required this.userStatus});
  final int userId;
  final bool userStatus;
  @override
  _AccountPrivacyScreenState createState() => _AccountPrivacyScreenState();
}

class _AccountPrivacyScreenState extends State<AccountPrivacyScreen> {
  late bool isPrivate;

  @override
  void initState() {
    super.initState();
    isPrivate = !widget.userStatus;
  }

  void _showConfirmationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Switch to private account?',
                style: TextStyle(
                    color: context.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildInfoRow(Icons.lock,
                  'Only your followers will be able to see your photos and videos.'),
              SizedBox(height: 10),
              _buildInfoRow(Icons.alternate_email,
                  "You won't be able to tag people who don't follow you."),
              SizedBox(height: 10),
              _buildInfoRow(Icons.link_off,
                  "No one can reuse your content. Content used in remixes or templates will be removed."),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.isDarkMode
                      ? Colors.grey.shade600
                      : Colors.grey.shade300,
                  minimumSize: Size(double.infinity, 48.h),
                ),
                onPressed: () async {
                  setState(() {
                    isPrivate = true;
                  });
                  var result = await sl<EditUserProfileUseCase>()
                      .call(EditUserProfileReq(isPublic: isPrivate));
                  result.fold((error) {}, (data) {});

                  Navigator.pop(context);
                },
                child: Text(
                  'Switch to private',
                  style: TextStyle(fontSize: AppSize.textMedium),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.secondBackground, size: AppSize.iconMedium),
        SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  color: context.isDarkMode ? Colors.white70 : Colors.black87,
                  fontSize: AppSize.textLarge)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Account Privacy',
          style: TextStyle(
              fontSize: AppSize.textHeading,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Private account',
                    style: TextStyle(
                        color: context.isDarkMode ? Colors.white : Colors.black,
                        fontSize: AppSize.textLarge)),
                Switch(
                  value: isPrivate,
                  onChanged: (val) async {
                    if (val) {
                      _showConfirmationDialog();
                    } else {
                      var result = await sl<EditUserProfileUseCase>()
                          .call(EditUserProfileReq(isPublic: isPrivate));
                      result.fold((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Update privacy Fail! Please try again'),
                          ),
                        );
                      }, (data) {
                        setState(() {
                          isPrivate = false;
                        });
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'When your account is public, your profile and posts can be seen by anyone...',
              style: TextStyle(
                  color: context.isDarkMode ? Colors.white70 : Colors.black87),
            ),
            SizedBox(height: 10),
            Text(
              'When your account is private, only the followers you approve can see your posts...',
              style: TextStyle(
                  color: context.isDarkMode ? Colors.white70 : Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
