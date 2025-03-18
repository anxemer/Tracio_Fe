import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

class SnapshotDisplayPage extends StatelessWidget {
  final Uri snapshotImage;
  final Widget metricsSection;

  const SnapshotDisplayPage({
    super.key,
    required this.snapshotImage,
    required this.metricsSection,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && Navigator.canPop(context)) {
          Navigator.pop(context, 'canceled');
        }
      },
      child: Scaffold(
          body: SafeArea(
              child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    snapshotImage.toString(),
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context, 'canceled');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.apHorizontalPadding,
                vertical: AppSize.apVerticalPadding),
            child: Column(
              children: [
                metricsSection,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 20,
                  children: [
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: AppColors.secondBackground,
                                  width: 1,
                                )),
                          ),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context, 'canceled');
                            }
                          },
                          child: Text("Navigate",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: AppSize.textMedium.sp)),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.secondBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context, 'save');
                            }
                          },
                          child: Text("Save",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppSize.textMedium.sp)),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ))),
    );
  }
}
