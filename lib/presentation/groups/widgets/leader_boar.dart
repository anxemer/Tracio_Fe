import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'
    show LoadingAnimationWidget;
import 'package:Tracio/common/bloc/generic_data_cubit.dart';
import 'package:Tracio/common/bloc/generic_data_state.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/challenge/entities/participants_entity.dart';
import 'package:Tracio/domain/challenge/entities/participants_response_entity.dart';
import 'package:Tracio/domain/challenge/usecase/get_participants.dart';
import 'package:Tracio/service_locator.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart'; // Cần cho định dạng số

class LeaderboardScreen extends StatefulWidget {
  final int challengeId;
  final int goalValue;

  const LeaderboardScreen(
      {super.key, required this.challengeId, required this.goalValue});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  // // Hàm gọi API (hoặc dữ liệu giả) để lấy leaderboard
  // Future<void> _fetchLeaderboard({bool loadMore = false}) async {
  //   // Ngăn chặn gọi lại khi đang tải hoặc đã hết dữ liệu
  //   if (loadMore && (_isLoadingMore || !_hasMoreData)) return;

  //   setState(() {
  //     if (loadMore) {
  //       _isLoadingMore = true;
  //     } else {
  //       _isLoading = true;
  //       _error = null; // Reset lỗi khi tải lại từ đầu
  //     }
  //   });

  //   try {
  //     // --- TODO: Thay thế bằng lệnh gọi API thật sự ---
  //     // Sử dụng widget.challengeId và _currentPage để gọi API
  //     print('Fetching page $_currentPage for challenge ${widget.challengeId}');
  //     final newData =
  //         await _fetchMockData(widget.challengeId, _currentPage, _pageSize);
  //     // ----------------------------------------------

  //     if (newData.isEmpty || newData.length < _pageSize) {
  //       // Nếu API trả về ít hơn số lượng yêu cầu hoặc rỗng -> Hết dữ liệu
  //       _hasMoreData = false;
  //     }

  //     if (mounted) {
  //       // Kiểm tra xem widget còn tồn tại không trước khi setState
  //       setState(() {
  //         _entries.addAll(newData); // Thêm dữ liệu mới vào danh sách
  //         _currentPage++; // Tăng số trang cho lần gọi tiếp theo
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching leaderboard: $e");
  //     if (mounted) {
  //       setState(() {
  //         _error = "Không thể tải bảng xếp hạng. Vui lòng thử lại.";
  //       });
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         if (loadMore) {
  //           _isLoadingMore = false;
  //         } else {
  //           _isLoading = false;
  //         }
  //       });
  //     }
  //   }
  // }

  // Hàm xử lý sự kiện cuộn để tải thêm
  // void _onScroll() {
  //   // Kiểm tra nếu người dùng đã cuộn gần đến cuối danh sách
  //   if (_scrollController.position.pixels >=
  //           _scrollController.position.maxScrollExtent * 0.9 &&
  //       !_isLoadingMore &&
  //       _hasMoreData) {
  //     _fetchLeaderboard(loadMore: true);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GenericDataCubit()
        ..getData<ParticipantsResponseEntity>(sl<GetParticipantsUseCase>(),
            params: widget.challengeId),
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            'Leaderboard',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppSize.textHeading,
                color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white, // Nền trắng cho body
        body: BlocBuilder<GenericDataCubit, GenericDataState>(
          builder: (context, state) {
            if (state is DataLoaded) {
              return _buildBodyContent(state.data);
            }
            if (state is DataLoading) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: AppColors.secondBackground,
                  size: AppSize.iconExtraLarge,
                ),
              );
            }
            if (state is FailureLoadData) {
              return SizedBox(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppImages.error,
                        width: AppSize.imageLarge,
                      ),
                      SizedBox(height: 16.h),
                      Text('No Participants yet. Pull down to refresh.'),
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildBodyContent(ParticipantsResponseEntity participants) {
    if (participants.listParticipants.isEmpty) {
      return const Center(child: Text("Leadboard Empty."));
    }
    
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: participants.listParticipants.length,
            itemBuilder: (context, index) {
              return _buildLeaderboardRow(participants.listParticipants[index],
                  true); // Xây dựng widget cho mỗi hàng
            },
          ),
        ),
        Divider(
          color: Colors.grey.shade300,
          height: 2,
          thickness: 10,
        ),
        if (participants.currentUser.challengeRank! > 10 ||
            participants.currentUser.challengeRank! == 0)
          _buildLeaderboardRow(participants.currentUser, false)
        else
          SizedBox.shrink()
      ],
    );  
  }

  Widget _buildLeaderboardRow(ParticipantsEntity participant, bool inTop) {
    int? currentValue = (participant.progress != null)
        ? (participant.progress! * widget.goalValue).round()
        : null;
    final bool isCurrentUser = participant.isCurrentUser!;
    final Color? rowColor = isCurrentUser ? AppColors.background : null;

    final FontWeight nameWeight =
        isCurrentUser ? FontWeight.bold : FontWeight.normal;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.apHorizontalPadding * .8.w,
      ),
      child: Row(
        children: [
          SizedBox(
            child: Text(
              '${participant.challengeRank == 0 ? '--' : participant.challengeRank}',
              style: TextStyle(
                  fontSize: AppSize.textMedium.sp,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Container(
                color: inTop ? rowColor : null,
                child: ListTile(
                  leading: CirclePicture(
                      imageUrl: participant.cyclistAvatarUrl!,
                      imageSize: AppSize.iconSmall.sp),
                  title: Text(
                    participant.cyclistName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: AppSize.textMedium,
                        fontWeight: nameWeight,
                        color: Colors.black87),
                  ),
                  subtitle: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: LinearProgressIndicator(
                      value: participant.progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.secondBackground),
                    ),
                  ),
                  trailing: Text(
                    currentValue.toString(),
                    style: TextStyle(
                        fontSize: AppSize.textLarge,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
