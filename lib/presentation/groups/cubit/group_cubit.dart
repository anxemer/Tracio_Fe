import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/data/groups/models/request/get_group_list_req.dart';
import 'package:tracio_fe/data/groups/models/request/post_group_req.dart';
import 'package:tracio_fe/domain/groups/usecases/get_group_detail_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/get_group_list_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/post_group_usecase.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_state.dart';
import 'package:tracio_fe/service_locator.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());

  void refreshState() {
    emit(GroupInitial());
  }

  Future<void> postGroup(PostGroupReq request) async {
    emit(GroupLoading());
    var data = await sl<PostGroupUsecase>().call(request);

    data.fold((error) {
      emit(GroupFailure(errorMessage: error.toString()));
    }, (data) async {
      emit(PostGroupSuccess(groupId: data, isSuccess: true));
    });
  }

  Future<void> getGroupList(GetGroupListReq request) async {
    emit(GroupLoading());
    var data = await sl<GetGroupListUsecase>().call(request);

    data.fold((error) {
      emit(GroupFailure(errorMessage: error.toString()));
    }, (data) async {
      emit(GetGroupListSuccess(
          pageSize: data.pageSize,
          pageNumber: data.pageNumber,
          totalCount: data.totalCount,
          totalPages: data.totalPages,
          hasNextPage: data.hasNextPage,
          hasPreviousPage: data.hasPreviousPage,
          groupList: data.groupList));
    });
  }

  Future<void> getGroupDetail(int groupId) async {
    emit(GroupLoading());
    var data = await sl<GetGroupDetailUsecase>().call(groupId);

    data.fold((error) {
      emit(GroupFailure(errorMessage: error.message));
    }, (data) async {
      emit(GetGroupDetailSuccess(group: data));
    });
  }
}
