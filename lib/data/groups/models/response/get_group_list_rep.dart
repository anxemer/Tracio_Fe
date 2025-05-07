import 'package:Tracio/data/groups/models/response/group_rep.dart';

class GetGroupListRep {
  List<GroupResponseModel> groupList;
  int totalCount;
  int pageNumber;
  int pageSize;
  int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;
  bool hasMyGroups;
  GetGroupListRep(
      {required this.groupList,
      required this.totalCount,
      required this.pageNumber,
      required this.pageSize,
      required this.totalPages,
      required this.hasPreviousPage,
      required this.hasNextPage,
      required this.hasMyGroups});

  GetGroupListRep copyWith(
      {List<GroupResponseModel>? groupList,
      int? totalCount,
      int? pageNumber,
      int? pageSize,
      int? totalPages,
      bool? hasPreviousPage,
      bool? hasNextPage,
      bool? hasMyGroups}) {
    return GetGroupListRep(
        groupList: groupList ?? this.groupList,
        totalCount: totalCount ?? this.totalCount,
        pageNumber: pageNumber ?? this.pageNumber,
        pageSize: pageSize ?? this.pageSize,
        totalPages: totalPages ?? this.totalPages,
        hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        hasMyGroups: hasMyGroups ?? this.hasMyGroups);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupList': groupList.map((x) => x.toMap()).toList(),
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
      'hasMyGroups': hasMyGroups
    };
  }

  factory GetGroupListRep.fromMap(Map<String, dynamic> map) {
    return GetGroupListRep(
        groupList: List<GroupResponseModel>.from(
          (map['items'] as List<dynamic>).map<GroupResponseModel>(
            (x) => GroupResponseModel.fromMap(x as Map<String, dynamic>),
          ),
        ),
        totalCount: map['totalCount'] as int,
        pageNumber: map['pageNumber'] as int,
        pageSize: map['pageSize'] as int,
        totalPages: map['totalPages'] as int,
        hasPreviousPage: map['hasPreviousPage'] as bool,
        hasNextPage: map['hasNextPage'] as bool,
        hasMyGroups: map['hasMyGroups'] as bool);
  }
}
