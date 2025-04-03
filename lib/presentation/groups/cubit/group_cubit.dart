import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/data/groups/models/request/post_group_req.dart';
import 'package:tracio_fe/domain/groups/usecases/post_group_usecase.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_state.dart';
import 'package:tracio_fe/service_locator.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());

  Future<void> postGroup(PostGroupReq request) async {
    emit(GroupLoading());
    var data = await sl<PostGroupUsecase>().call(request);

    data.fold((error) {
      emit(GroupFailure(errorMessage: error.toString()));
    }, (data) async {
      emit(PostGroupSuccess(isSuccess: true));
    });
  }
}
