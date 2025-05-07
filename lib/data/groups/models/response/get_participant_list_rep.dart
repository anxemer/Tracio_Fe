import 'package:Tracio/domain/groups/entities/group_route.dart';
import 'package:Tracio/domain/groups/entities/group_route.dart';

class GetParticipantListRep extends GroupParticipantPaginationEntity {
  GetParticipantListRep({
    required super.participants,
    required super.totalCount,
    required super.pageNumber,
    required super.pageSize,
    required super.totalPages,
    required super.hasPreviousPage,
    required super.hasNextPage,
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
