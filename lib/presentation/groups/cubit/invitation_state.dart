part of 'invitation_bloc.dart';

enum InvitationStatus { initial, loading, success, failure }

enum InvitationActionType {
  none,
  delete,
  accept,
  decline,
  requestJoin,
  sendInvite
}

class InvitationState extends Equatable {
  final List<Invitation> invitations;
  final InvitationStatus status;
  final Failure? failure;
  final InvitationActionType lastAction;
  final List<Invitation>? previousInvitations;
  final int? groupId;
  final int? userId;

  const InvitationState({
    this.invitations = const [],
    this.status = InvitationStatus.initial,
    this.failure,
    this.lastAction = InvitationActionType.none,
    this.previousInvitations,
    this.groupId,
    this.userId,
  });

  InvitationState copyWith({
    List<Invitation>? invitations,
    InvitationStatus? status,
    Failure? failure,
    InvitationActionType? lastAction,
    List<Invitation>? previousInvitations,
    int? groupId,
    int? userId,
  }) {
    return InvitationState(
      invitations: invitations ?? this.invitations,
      status: status ?? this.status,
      failure: failure,
      lastAction: lastAction ?? this.lastAction,
      previousInvitations: previousInvitations ?? this.previousInvitations,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props =>
      [invitations, status, failure, lastAction, previousInvitations];
}
