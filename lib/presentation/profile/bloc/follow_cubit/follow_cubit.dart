import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/user/entities/follow_entity.dart';
import 'package:Tracio/domain/user/usecase/get_follower.dart';
import 'package:Tracio/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/user/usecase/get_following.dart';

part 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  FollowCubit() : super(FollowInitial());

  void getFollower(int userId) async {
    emit(FollowLoading());
    var result = await sl<GetFollowerUseCase>().call(userId);
    result.fold((error) {
      emit(FollowFailure(error));
    }, (data) {
      emit(FollowLoaded(data));
    });
  }

  void getFollowing(int userId) async {
    emit(FollowLoading());
    var result = await sl<GetFollowingUseCase>().call(userId);
    result.fold((error) {
      emit(FollowFailure(error));
    }, (data) {
      emit(FollowLoaded(data));
    });
  }
}
