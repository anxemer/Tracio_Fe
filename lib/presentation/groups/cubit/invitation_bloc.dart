import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/domain/groups/entities/invitation.dart';
import 'package:tracio_fe/domain/groups/usecases/invitations/accept_group_invitation_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/invitations/invite_user_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/invitations/request_to_join_group_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/invitations/response_join_group_request_usecase.dart';
import 'package:tracio_fe/service_locator.dart';

part 'invitation_event.dart';
part 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  InvitationBloc() : super(InvitationState()) {
    on<InvitationSubscriptionRequested>(_onSubscriptionRequested);
    on<SendInvitation>(_onSendInvitation);
    on<RequestJoin>(_onRequestJoin);
    on<InvitationDeleted>(_onInvitationDeleted);
    on<InvitationAccepted>(_onInvitationAccepted);
    on<InvitationDeclined>(_onInvitationDeclined);
    on<RequestAccepted>(_onRequestAccepted);
    on<RequestDeclined>(_onRequestDeclined);
  }

  //Variables:
  final List<int> _userIds = [];
  final List<int> _groupIds = [];
  void _onSubscriptionRequested(InvitationSubscriptionRequested event,
      Emitter<InvitationState> emit) async {
    emit(state.copyWith(status: InvitationStatus.loading));
  }

  void _onSendInvitation(
      SendInvitation event, Emitter<InvitationState> emit) async {
    var preAction = InvitationActionType.none;
    emit(state.copyWith(lastAction: InvitationActionType.sendInvite));
    _userIds.add(event.userId);

    await sl<InviteUserUsecase>()
        .call(InviteUserParams(
      groupId: event.groupId,
      inviteeIds: _userIds,
    ))
        .then((result) {
      result.fold(
        (failure) {
          emit(state.copyWith(
              lastAction: preAction,
              status: InvitationStatus.failure,
              failure: failure));
        },
        (response) {
          emit(state.copyWith(status: InvitationStatus.success));
        },
      );
    });
  }

  void _onRequestJoin(RequestJoin event, Emitter<InvitationState> emit) async {
    var preAction = InvitationActionType.none;
    emit(state.copyWith(
        lastAction: InvitationActionType.requestJoin,
        status: InvitationStatus.loading));
    _groupIds.add(event.groupId);
    final result = await sl<RequestToJoinGroupUsecase>().call(event.groupId);

    result.fold(
      (failure) {
        emit(state.copyWith(
          lastAction: preAction,
          status: InvitationStatus.failure,
          failure: failure,
          groupId: event.groupId,
        ));
      },
      (response) {
        emit(state.copyWith(
          status: InvitationStatus.success,
          groupId: event.groupId,
        ));
      },
    );
  }

  void _onInvitationDeleted(
      InvitationDeleted event, Emitter<InvitationState> emit) {
    // Handle invitation deletion
  }
  void _onInvitationAccepted(
      InvitationAccepted event, Emitter<InvitationState> emit) async {
    await sl<AcceptGroupInvitationUsecase>()
        .call(AcceptGroupInvitationParam(
            invitationId: event.invitationId, isApproved: true))
        .then((result) {
      result.fold(
        (failure) {
          emit(state.copyWith(
              status: InvitationStatus.failure, failure: failure));
        },
        (response) {
          emit(state.copyWith(status: InvitationStatus.success));
        },
      );
    });
  }

  void _onInvitationDeclined(
      InvitationDeclined event, Emitter<InvitationState> emit) async {
    await sl<AcceptGroupInvitationUsecase>()
        .call(AcceptGroupInvitationParam(
            invitationId: event.invitationId, isApproved: false))
        .then((result) {
      result.fold(
        (failure) {
          emit(state.copyWith(
              status: InvitationStatus.failure, failure: failure));
        },
        (response) {
          emit(state.copyWith(status: InvitationStatus.success));
        },
      );
    });
  }

  void _onRequestAccepted(
      RequestAccepted event, Emitter<InvitationState> emit) async {
    await sl<ResponseJoinGroupRequestUsecase>()
        .call(ResponseJoinGroupRequestParam(
            invitationId: event.invitationId, isApproved: true))
        .then((result) {
      result.fold(
        (failure) {
          emit(state.copyWith(
              status: InvitationStatus.failure, failure: failure));
        },
        (response) {
          emit(state.copyWith(status: InvitationStatus.success));
        },
      );
    });
  }

  void _onRequestDeclined(
      RequestDeclined event, Emitter<InvitationState> emit) async {
    await sl<ResponseJoinGroupRequestUsecase>()
        .call(ResponseJoinGroupRequestParam(
            invitationId: event.invitationId, isApproved: false))
        .then((result) {
      result.fold(
        (failure) {
          emit(state.copyWith(
              status: InvitationStatus.failure, failure: failure));
        },
        (response) {
          emit(state.copyWith(status: InvitationStatus.success));
        },
      );
    });
  }
}
