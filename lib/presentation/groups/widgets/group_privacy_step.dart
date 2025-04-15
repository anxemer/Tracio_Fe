import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/groups/cubit/form_group_cubit.dart';

class GroupPrivacyStep extends StatefulWidget {
  const GroupPrivacyStep({super.key});

  @override
  State<GroupPrivacyStep> createState() => _GroupPrivacyStepState();
}

class _GroupPrivacyStepState extends State<GroupPrivacyStep> {
  String _groupPrivacy = 'public'; // Default to 'public'

  @override
  void initState() {
    super.initState();
    final isPublic = context.read<FormGroupCubit>().state.groupRequest.isPublic;
    _groupPrivacy = isPublic ? 'public' : 'private';
  }

  void _onPrivacyChanged(String? value) {
    if (value != null) {
      setState(() {
        _groupPrivacy = value;
      });

      context.read<FormGroupCubit>().updatePrivacy(value == 'public');
      context.read<FormGroupCubit>().validateStep(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Private or Public",
          style: TextStyle(
            fontSize: AppSize.textHeading.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        RadioListTile<String>(
          value: 'public',
          groupValue: _groupPrivacy,
          onChanged: _onPrivacyChanged,
          title: Text(
            "Public",
            style: TextStyle(fontSize: AppSize.textMedium * 1.2.sp),
          ),
          subtitle: _groupPrivacy == 'public'
              ? Text(
                  "Anyone on Tracio can join your group and view recent activity and content.",
                  style: TextStyle(
                      fontSize: AppSize.textMedium.sp, color: Colors.grey),
                )
              : null,
        ),
        SizedBox(height: 16),
        RadioListTile<String>(
          value: 'private',
          groupValue: _groupPrivacy,
          onChanged: _onPrivacyChanged,
          title: Text(
            "Private",
            style: TextStyle(fontSize: AppSize.textMedium * 1.2.sp),
          ),
          subtitle: _groupPrivacy == 'private'
              ? Text(
                  "People must request permission to join your group. Only admins can approve new members.",
                  style: TextStyle(
                      fontSize: AppSize.textMedium.sp, color: Colors.grey),
                )
              : null,
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
    );
  }
}
