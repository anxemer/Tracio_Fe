import 'package:Tracio/domain/map/entities/place.dart';

class GetPlacesRep {
  final List<Prediction> predictions;
  final int? executedTime;
  final int? executedTimeAll;
  final String status;

  GetPlacesRep({
    required this.predictions,
    this.executedTime,
    this.executedTimeAll,
    required this.status,
  });

  factory GetPlacesRep.fromJson(Map<String, dynamic> json) =>
      GetPlacesRep.fromMap(json);

  factory GetPlacesRep.fromMap(Map<String, dynamic> json) => GetPlacesRep(
        predictions: List<Prediction>.from(
            json["predictions"].map((x) => Prediction.fromMap(x))),
        executedTime: json["executed_time"],
        executedTimeAll: json["executed_time_all"],
        status: json["status"],
      );
}

class Prediction {
  final String description;
  final String placeId;
  final String reference;
  final StructuredFormatting structuredFormatting;
  final bool hasChildren;
  final String? displayType;
  final double? score;
  final PlusCode plusCode;

  Prediction({
    required this.description,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.hasChildren,
    this.displayType,
    this.score,
    required this.plusCode,
  });

  factory Prediction.fromMap(Map<String, dynamic> json) => Prediction(
        description: json["description"],
        placeId: json["place_id"],
        reference: json["reference"],
        structuredFormatting:
            StructuredFormatting.fromMap(json["structured_formatting"]),
        hasChildren: json["has_children"],
        displayType: json["display_type"],
        score: json["score"]?.toDouble(),
        plusCode: PlusCode.fromMap(json["plus_code"]),
      );
}

class StructuredFormatting {
  final String mainText;
  final String secondaryText;

  StructuredFormatting({
    required this.mainText,
    required this.secondaryText,
  });

  factory StructuredFormatting.fromMap(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"],
        secondaryText: json["secondary_text"],
      );
}

class PlusCode {
  final String compoundCode;
  final String globalCode;

  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  factory PlusCode.fromMap(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
      );
}

extension GetPlacesRepExtension on GetPlacesRep {
  List<PlaceEntity> toEntity() {
    return predictions
        .map((place) => PlaceEntity(
              placeId: place.placeId,
              description: place.description,
              mainText: place.structuredFormatting.mainText,
              secondaryText: place.structuredFormatting.secondaryText,
            ))
        .toList();
  }
}

class GetPlaceDetailRep {
  final PlaceDetail result;
  final String status;

  GetPlaceDetailRep({
    required this.result,
    required this.status,
  });

  factory GetPlaceDetailRep.fromJson(Map<String, dynamic> json) {
    return GetPlaceDetailRep(
      result: PlaceDetail.fromJson(json['result']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result.toJson(),
      'status': status,
    };
  }
}

class PlaceDetail {
  final String placeId;
  final String formattedAddress;
  final Geometry geometry;
  final String name;

  PlaceDetail({
    required this.placeId,
    required this.formattedAddress,
    required this.geometry,
    required this.name,
  });

  factory PlaceDetail.fromJson(Map<String, dynamic> json) {
    return PlaceDetail(
      placeId: json['place_id'],
      formattedAddress: json['formatted_address'],
      geometry: Geometry.fromJson(json['geometry']),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'formatted_address': formattedAddress,
      'geometry': geometry.toJson(),
      'name': name,
    };
  }
}

class Geometry {
  final Location location;

  Geometry({required this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
    };
  }
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

extension GetPlaceDetailRepExtension on GetPlaceDetailRep {
  PlaceDetailEntity toEntity() {
    return PlaceDetailEntity(
      placeId: result.placeId,
      name: result.name,
      address: result.formattedAddress,
      latitude: result.geometry.location.lat,
      longitude: result.geometry.location.lng,
    );
  }
}
