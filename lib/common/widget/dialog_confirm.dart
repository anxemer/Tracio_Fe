// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_size.dart';



class DialogConfirm {
  VoidCallback btnLeft;
  VoidCallback btnRight;
  String? textLeft;
  String? textRight;
  String? notification;
  DialogConfirm({
    required this.btnLeft,
    required this.btnRight,
    this.textLeft,
    this.textRight,
    this.notification,
  });
  void showDialogConfirmation(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(20),
          children: [
            Icon(Icons.info_outline_rounded,
                size: AppSize.iconLarge, color: Colors.black38),
            SizedBox(
              height: 10.h,
            ),
            Text(
              notification ?? 'Are you sure you want to confirm this booking?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: AppSize.textLarge,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: btnLeft,
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(Colors.red),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(textLeft ?? 'Yes, I\'m sure'),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: btnRight,
                    style: ButtonStyle(
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.black54),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(textRight ?? 'No'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
