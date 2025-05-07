import 'dart:async'; // Cần cho Timer
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/domain/challenge/entities/challenge_entity.dart';
import 'package:Tracio/presentation/groups/widgets/challenge_progress.dart';

class ChallengeJoiningLoadingScreen extends StatefulWidget {
  // Thêm tham số để nhận dữ liệu challenge nếu cần chuyển sang màn hình tiếp theo
  // final Challenge challenge; // Ví dụ
  final ChallengeEntity challengeEntity;
  const ChallengeJoiningLoadingScreen({
    super.key,
    required this.challengeEntity,
    // required this.challenge, // Ví dụ
  });

  @override
  State<ChallengeJoiningLoadingScreen> createState() =>
      _ChallengeJoiningLoadingScreenState();
}

class _ChallengeJoiningLoadingScreenState
    extends State<ChallengeJoiningLoadingScreen> {
  Timer? _timer; // Biến để giữ Timer

  @override
  void initState() {
    super.initState();
    _startTimerAndNavigate();
  }

  void _startTimerAndNavigate() {
    // Tạo một Timer chạy một lần sau 2 giây
    _timer = Timer(const Duration(seconds: 2), () {
      // Kiểm tra xem widget còn tồn tại không trước khi điều hướng
      if (mounted) {
        // --- Điều hướng đến màn hình tiếp theo ---
        // Sử dụng pushReplacement để màn hình loading bị loại bỏ khỏi stack,
        // người dùng không thể nhấn back quay lại màn hình này.

        // Ví dụ: Chuyển đến màn hình ChallengeProgressScreen và truyền dữ liệu challenge
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => ChallengeProgressScreen(challenge: widget.challenge),
        //   ),
        // );

        // --- Hoặc chuyển đến một màn hình Placeholder nếu chưa có màn hình đích ---
        AppNavigator.pushAndRemove(
            context,
            ChallengeProgressScreen(
              challenge: widget.challengeEntity,
            ));
      }
    });
  }

  @override
  void dispose() {
    // Hủy Timer nếu widget bị hủy trước khi Timer chạy xong
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Màu sắc giống Nike (ví dụ: nền đen, animation trắng/teal)
    const Color nikeLoadingColor = Colors.white; // Hoặc Colors.tealAccent[400];
    const Color backgroundColor = Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor, // Nền đen
      body: Center(
        child: LoadingAnimationWidget.inkDrop(
          color: nikeLoadingColor, // Màu của animation
          size: 80, // Kích thước animation
        ),
      ),
    );
  }
}
