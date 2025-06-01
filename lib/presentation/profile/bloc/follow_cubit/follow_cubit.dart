import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/user/models/get_follow_req.dart';
import 'package:Tracio/domain/user/entities/follow_entity.dart';
import 'package:Tracio/domain/user/entities/pagination_follow_data_entity.dart';
import 'package:Tracio/domain/user/usecase/get_follower.dart';
import 'package:Tracio/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/user/usecase/get_following.dart';

part 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  FollowCubit()
      : super(FollowInitial([], PaginationFollowDataEntity(), GetFollowReq()));

  void getFollower(GetFollowReq params) async {
    emit(FollowLoading([], state.pagination, params));
    var result = await sl<GetFollowerUseCase>().call(params);
    result.fold((error) {
      emit(FollowFailure(state.follow, state.pagination, state.params, error));
    }, (data) {
      emit(FollowLoaded(data.follow, data.pagination, state.params));
    });
  }

  void getFollowing(GetFollowReq params) async {
    emit(FollowLoading([], state.pagination, params));
    var result = await sl<GetFollowingUseCase>().call(params);
    result.fold((error) {
      emit(FollowFailure(state.follow, state.pagination, state.params, error));
    }, (data) {
      emit(FollowLoaded(data.follow, data.pagination, state.params));
    });
  }

  void getMoreFollower(int userId) async {
    final currentState = state;

    if (currentState is FollowLoaded) {
      try {
        emit(FollowLoaded(
            currentState.follow, currentState.pagination, currentState.params));

        final nextPage = currentState.pagination.pageNumber! + 1;
        final result = await sl<GetFollowingUseCase>()
            .call(GetFollowReq(userId: userId, pageNumber: nextPage));

        result.fold((error) {
          emit(FollowFailure(currentState.follow, currentState.pagination,
              currentState.params, error));
        }, (data) {
          final updatedFollows = List<FollowEntity>.from(currentState.follow);
          updatedFollows.addAll(data.follow);
          emit(FollowLoaded(
            updatedFollows,
            data.pagination,
            GetFollowReq(),
          ));
        });
      } catch (e) {
        if (currentState is FollowLoaded) {
          emit(FollowLoaded(currentState.follow, currentState.pagination,
              currentState.params));
        }
      }
    }
  }

  void getMoreFollowing(int userId) async {
    final currentState = state;

    if (currentState is FollowLoaded) {
      try {
        emit(FollowLoaded(
            currentState.follow, currentState.pagination, currentState.params));

        final nextPage = currentState.pagination.pageNumber! + 1;
        final result = await sl<GetFollowingUseCase>()
            .call(GetFollowReq(userId: userId, pageNumber: nextPage));

        result.fold((error) {
          emit(FollowFailure(currentState.follow, currentState.pagination,
              currentState.params, error));
        }, (data) {
          final updatedFollows = List<FollowEntity>.from(currentState.follow);
          updatedFollows.addAll(data.follow);
          emit(FollowLoaded(
            updatedFollows,
            data.pagination,
            GetFollowReq(),
          ));
        });
      } catch (e) {
        if (currentState is FollowLoaded) {
          emit(FollowLoaded(currentState.follow, currentState.pagination,
              currentState.params));
        }
      }
    }
  }
}
