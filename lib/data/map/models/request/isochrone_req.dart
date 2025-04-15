class IsochroneReq {
  double lng;
  double lat;
  int? contourMinutes;
  int? contourDistance;
  String? contourColors;
  bool polygon;
  int generalize;
  String accessToken;
  int denoise;

  IsochroneReq({
    required this.lng,
    required this.lat,
    this.contourMinutes,
    this.contourDistance,
    this.contourColors,
    this.polygon = true,
    this.generalize = 500,
    required this.accessToken,
    this.denoise = 1,
  }) {
    // Ensure only one of contourMinutes or contourDistance is set
    assert(
      (contourMinutes != null && contourDistance == null) ||
      (contourMinutes == null && contourDistance != null),
      "Either `contourMinutes` or `contourDistance` must be provided, not both.",
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> params = {
      'polygons': polygon.toString(),
      'generalize': generalize.toString(),
      'access_token': accessToken,
      'denoise': denoise.toString(),
    };

    // ✅ Corrected key: "contours_meters" for distance
    if (contourMinutes != null) {
      params['contours_minutes'] = contourMinutes.toString();
    } else if (contourDistance != null) {
      params['contours_meters'] = contourDistance.toString();
    }

    // ✅ Corrected "contours_colors"
    if (contourColors != null) {
      params['contours_colors'] = contourColors;
    }

    return params;
  }

  static Uri urlGetIsochroneMapbox(IsochroneReq request) {
    final coordsString = "${request.lng},${request.lat}"; // ✅ Correct format

    final uri = Uri.https(
      'api.mapbox.com',
      '/isochrone/v1/mapbox/cycling/$coordsString',
      request.toMap(),
    );

    return uri;
  }
}
