part of 'invitation_bloc.dart';

sealed class InvitationEvent extends Equatable {
  const InvitationEvent();

  @override
  List<Object> get props => [];
}

/// For initial loading or subscription
final class InvitationSubscriptionRequested extends InvitationEvent {
  const InvitationSubscriptionRequested();
}

/// Send group invitation to user(s)
final class SendInvitation extends InvitationEvent {
  const SendInvitation({
    required this.groupId,
    required this.userId,
  });

  final int groupId;
  final int userId;

  @override
  List<Object> get props => [groupId, userId];
}

/// User requests to join a group
final class RequestJoin extends InvitationEvent {
  const RequestJoin(this.groupId);

  final int groupId;

  @override
  List<Object> get props => [groupId];
}

/// Base class for actions that act on an invitationId
abstract class InvitationActionEvent extends InvitationEvent {
  const InvitationActionEvent(this.invitationId);

  final int invitationId;

  @override
  List<Object> get props => [invitationId];
}

/// Delete an invitation or request
final class InvitationDeleted extends InvitationActionEvent {
  const InvitationDeleted(super.invitationId);
}

/// Accept a group invitation
final class InvitationAccepted extends InvitationActionEvent {
  const InvitationAccepted(super.invitationId);
}

/// Decline a group invitation
final class InvitationDeclined extends InvitationActionEvent {
  const InvitationDeclined(super.invitationId);
}

/// Accept a user's request to join
final class RequestAccepted extends InvitationActionEvent {
  const RequestAccepted(super.invitationId);
}

/// Decline a user's request to join
final class RequestDeclined extends InvitationActionEvent {
  const RequestDeclined(super.invitationId);
}
