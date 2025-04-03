import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/groups/pages/create_group.dart';
import 'package:tracio_fe/presentation/groups/widgets/recommend_group_item.dart';

class GroupTab extends StatefulWidget {
  const GroupTab({super.key});

  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          // Create your group
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.apHorizontalPadding,
                vertical: AppSize.apVerticalPadding / 2),
            child: Row(
              children: [
                Text("Create your own Group"),
                Spacer(),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                    side: WidgetStatePropertyAll(
                        BorderSide(color: AppColors.primary, width: 1)),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateGroupScreen()));
                  },
                  child: Text(
                    "Create a group",
                    style: TextStyle(
                        fontSize: AppSize.textSmall.sp,
                        color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),

          // List my group
          SizedBox(height: AppSize.apSectionPadding),

          // Groups near you
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.apHorizontalPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: AppSize.apHorizontalPadding / 2,
                  children: [
                    Icon(
                      Icons.local_attraction_rounded,
                      size: AppSize.iconMedium,
                    ),
                    Text("Popular Public Groups Near You",
                        style: TextStyle(
                            fontSize: AppSize.textSmall.sp,
                            fontWeight: FontWeight.w600)),
                  ],
                ),

                // List of recommended groups
                SizedBox(height: 16),
              ],
            ),
          ),
          Wrap(
            spacing: AppSize.apHorizontalPadding / 4,
            runSpacing: AppSize.apHorizontalPadding / 4,
            children: List.generate(
              12,
              (index) {
                return RecommendGroupItem(
                  groupImageUrl: 'https://www.eurobasket.com/logos/torr.png',
                  groupName: 'Group tên dài quá dài',
                  address: 'Hà nội, Hồ Chí Minh, Bình Định, Bình Dương',
                  memberCount: 12126,
                );
              },
            ),
          ),

          const SizedBox(
            height: AppSize.apVerticalPadding,
          ),
        ],
      ),
    );
  }
}
