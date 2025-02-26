// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetPlaceReq {
  String searchText;
  double? limit;
  double? radius;
  String? sessionToken;

  GetPlaceReq({
    required this.searchText,
    this.limit,
    this.radius,
    this.sessionToken,
  });

  GetPlaceReq copyWith({
    String? searchText,
    double? limit,
    double? radius,
    String? sessionToken,
  }) {
    return GetPlaceReq(
      searchText: searchText ?? this.searchText,
      limit: limit ?? this.limit,
      radius: radius ?? this.radius,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'searchText': searchText,
      'limit': limit,
      'radius': radius,
      'sessionToken': sessionToken,
    };
  }

  factory GetPlaceReq.fromMap(Map<String, dynamic> map) {
    return GetPlaceReq(
      searchText: map['searchText'] as String,
      limit: map['limit'] != null ? map['limit'] as double : null,
      radius: map['radius'] != null ? map['radius'] as double : null,
      sessionToken:
          map['sessionToken'] != null ? map['sessionToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetPlaceReq.fromJson(String source) =>
      GetPlaceReq.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetPlaceReq(searchText: $searchText, limit: $limit, radius: $radius, sessionToken: $sessionToken)';
  }

  @override
  bool operator ==(covariant GetPlaceReq other) {
    if (identical(this, other)) return true;

    return other.searchText == searchText &&
        other.limit == limit &&
        other.radius == radius &&
        other.sessionToken == sessionToken;
  }

  @override
  int get hashCode {
    return searchText.hashCode ^
        limit.hashCode ^
        radius.hashCode ^
        sessionToken.hashCode;
  }
}

class GetPlaceDetailReq {
  String placeId;
  String? sessionToken;
  GetPlaceDetailReq({
    required this.placeId,
    this.sessionToken,
  });

  GetPlaceDetailReq copyWith({
    String? placeId,
    String? sessionToken,
  }) {
    return GetPlaceDetailReq(
      placeId: placeId ?? this.placeId,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placeId': placeId,
      'sessionToken': sessionToken,
    };
  }

  factory GetPlaceDetailReq.fromMap(Map<String, dynamic> map) {
    return GetPlaceDetailReq(
      placeId: map['placeId'] as String,
      sessionToken:
          map['sessionToken'] != null ? map['sessionToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetPlaceDetailReq.fromJson(String source) =>
      GetPlaceDetailReq.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GetPlaceDetailReq(placeId: $placeId, sessionToken: $sessionToken)';

  @override
  bool operator ==(covariant GetPlaceDetailReq other) {
    if (identical(this, other)) return true;

    return other.placeId == placeId && other.sessionToken == sessionToken;
  }

  @override
  int get hashCode => placeId.hashCode ^ sessionToken.hashCode;
}
