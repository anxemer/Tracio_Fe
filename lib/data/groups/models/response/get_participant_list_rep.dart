import 'package:tracio_fe/domain/groups/entities/group_route.dart';

class GetParticipantListRep {
  final List<Participant> participants;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  GetParticipantListRep({
    required this.participants,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory GetParticipantListRep.fromMap(Map<String, dynamic> map) {
    return GetParticipantListRep(
      participants: List<Participant>.from(
        (map['items'] as List).map(
          (x) => Participant.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalCount: map['totalCount'] as int,
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalPages: map['totalPages'] as int,
      hasPreviousPage: map['hasPreviousPage'] as bool,
      hasNextPage: map['hasNextPage'] as bool,
    );
  }
}
