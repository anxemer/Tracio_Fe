class Invitation {
  final int invitationId;
  final int? challengeId;
  final int? groupId;
  final int? inviterId;
  final int inviteeId;
  final String status;
  final DateTime invitedAt;
  final DateTime? respondedAt;

  Invitation({
    required this.invitationId,
    this.challengeId,
    this.groupId,
    this.inviterId,
    required this.inviteeId,
    required this.status,
    required this.invitedAt,
    this.respondedAt,
  });

  factory Invitation.fromMap(Map<String, dynamic> map) {
    return Invitation(
      invitationId: map['invitationId'],
      challengeId: map['challengeId'],
      groupId: map['groupId'],
      inviterId: map['inviterId'],
      inviteeId: map['inviteeId'],
      status: map['status'],
      invitedAt: DateTime.parse(map['invitedAt']),
      respondedAt: map['respondedAt'] != null
          ? DateTime.tryParse(map['respondedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invitationId': invitationId,
      'challengeId': challengeId,
      'groupId': groupId,
      'inviterId': inviterId,
      'inviteeId': inviteeId,
      'status': status,
      'invitedAt': invitedAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
    };
  }
}
