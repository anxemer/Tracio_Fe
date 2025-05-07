import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/challenge/entities/challenge_entity.dart';
import 'package:Tracio/domain/challenge/entities/challenge_overview_response_entity.dart';
import 'package:Tracio/domain/challenge/usecase/get_challenge_detail.dart';
import 'package:Tracio/domain/challenge/usecase/get_challenge_overview.dart';
import 'package:Tracio/domain/challenge/usecase/join_challenge.dart';
import 'package:Tracio/service_locator.dart';

part 'challenge_state.dart';

class ChallengeCubit extends Cubit<ChallengeState> {
  ChallengeCubit() : super(ChallengeInitial());

  void getChallengeOverview() async {
    emit(ChallengeLoading());
    var result = await sl<GetChallengeOverviewUseCase>().call(NoParams());
    result.fold((error) {
      emit(ChallengeFailure(error.message, error));
    }, (data) {
      emit(ChallengeLoaded(data));
    });
  }

  void getChallengeDetail(int params) async {
    emit(ChallengeLoading());
    var result = await sl<GetChallengeDetailUseCase>().call(params);
    result.fold((error) {
      emit(ChallengeFailure(error.message, error));
    }, (data) {
      emit(ChallengeDetailLoaded(data));
    });
  }

  void joinChallenge(int params) async {
    var result = await sl<JoinChallengeUseCase>().call(params);
    result.fold((error) {
      emit(ChallengeFailure(error.message, error));
    }, (data) {
      emit(JoinChallengeLoaded());
    });
  }
}
