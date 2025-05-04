import 'package:flutter/material.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

class ChallengesTabScreen extends StatelessWidget {
  const ChallengesTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sử dụng ListView để nội dung có thể cuộn nếu dài hơn màn hình
    // Widget này sẽ kế thừa Theme từ context nơi nó được gọi
    // (ví dụ: từ MaterialApp trong cây widget cha)
    return Scaffold(
      appBar: BasicAppbar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Challege',
          style: TextStyle(
              fontSize: AppSize.textHeading, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        children: [
          _buildFeaturedBanner(context),
          SizedBox(height: 25),
          _buildCreateButton(context),
          _buildSectionHeader(context, 'My Challenges'),
          _buildMyChallengeItem(
            context,
            iconText: '10K',
            title: 'March Weekly Challenge',
            progress: '0.00 / 10.00 km',
            timeLeft: '11h 3m left',
          ),
          // Bạn có thể thêm các _buildMyChallengeItem khác ở đây nếu người dùng
          // tham gia nhiều thử thách
          // Ví dụ:
          // _buildMyChallengeItem(
          //   context,
          //   iconText: '50K',
          //   title: 'April Monthly Challenge',
          //   progress: '25.50 / 50.00 km',
          //   timeLeft: '20d left',
          // ),
          SizedBox(height: 30),
          _buildSectionHeader(context, 'Join a Challenge',
              showViewAll: true), // Tiêu đề "Join a Challenge"

          _buildJoinChallengeCard(context), // Thẻ ví dụ
        ],
      ),
    );
  }

  Widget _buildFeaturedBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.symmetric(vertical: 25.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.hexagon_outlined,
                  size: 90, color: Colors.white.withOpacity(0.6)),
              Text(
                '100K',
                style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Join 46,772 runners',
            style:
                TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            print("Create Challenge button tapped");
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          child: Text('Create a Challenge'),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title,
      {bool showViewAll = false}) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 10.0, top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white // Đảm bảo chữ màu trắng nếu theme tối
                    ) ??
                TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
          ),
          if (showViewAll)
            InkWell(
              onTap: () {
                // TODO: Xử lý sự kiện nhấn "View all"
                print("View all tapped for $title");
              },
              child: Padding(
                // Thêm padding để dễ nhấn hơn
                padding: const EdgeInsets.all(8.0),
                child: Text('View all',
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ),
            ),
        ],
      ),
    );
  }

  // Widget cho một mục trong danh sách "My Challenges"
  Widget _buildMyChallengeItem(
    BuildContext context, {
    required String iconText,
    required String title,
    required String progress,
    required String timeLeft,
  }) {
    final Color accentColor =
        Theme.of(context).colorScheme.secondary ?? Colors.orange;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Xử lý sự kiện nhấn vào một thử thách
          print("Tapped on challenge: $title");
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                width: 60, // Cho chiều rộng cố định để icon đều nhau
                height: 45, // Chiều cao cố định
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  iconText,
                  style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      progress,
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                    SizedBox(height: 3),
                    Text(
                      timeLeft,
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                  ],
                ),
              ),
              Padding(
                // Thêm padding để dễ nhấn icon chevron hơn
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.chevron_right,
                    color: Colors.grey[600], size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget ví dụ cho một thẻ trong phần "Join a Challenge"
  Widget _buildJoinChallengeCard(BuildContext context) {
    return InkWell(
      // Bọc trong InkWell để có thể nhấn
      onTap: () {
        // TODO: Xử lý sự kiện nhấn vào thẻ thử thách cộng đồng
        print("Tapped on joinable challenge card");
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Lấy màu từ theme hoặc màu cố định
          color: Theme.of(context).cardColor ?? Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.emoji_events_outlined,
                color: Colors.amber, size: 30), // Icon ví dụ
            SizedBox(width: 16),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Community 100KM",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Run with the community!",
                    style: TextStyle(color: Colors.grey[400], fontSize: 13)),
              ],
            )),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 28),
          ],
        ),
      ),
    );
  }
} // End of ChallengesTabScreen
