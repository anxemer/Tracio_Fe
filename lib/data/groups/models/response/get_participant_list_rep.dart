import 'package:tracio_fe/domain/groups/entities/group_route.dart';

class GetParticipantListRep {
  final List<Cyclist> cyclists;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  GetParticipantListRep({
    required this.cyclists,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory GetParticipantListRep.fromMap(Map<String, dynamic> map) {
    return GetParticipantListRep(
      cyclists: List<Cyclist>.from(
        (map['items'] as List).map(
          (x) => Cyclist.fromMap(x as Map<String, dynamic>),
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

class Cyclist {
  bool isOrganizer;
  DateTime joinAt;
  Participant participant;
  int cyclistId;
  Cyclist({
    required this.cyclistId,
    required this.isOrganizer,
    required this.participant,
    required this.joinAt,
  });

  factory Cyclist.fromMap(Map<String, dynamic> map) {
    return Cyclist(
      cyclistId: map['cyclistId'] as int,
      isOrganizer: map['isOrganizer'] as bool,
      participant: Participant.fromMap(map['cyclist'] as Map<String, dynamic>),
      joinAt: DateTime.parse(map['joinAt'] as String),
    );
  }
}
