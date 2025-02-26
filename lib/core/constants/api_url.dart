import 'package:tracio_fe/data/map/models/get_place_req.dart';
import 'package:tracio_fe/data/map/models/mapbox_direction_req.dart';

class ApiUrl {
  //base Url
  static const baseURL = 'http://192.168.1.9:';
  // static const baseURL = 'http://10.87.46.103:';
  //port
  static const portUser = '5186';
  static const portBlog = '5265';

  //Api User
  static const registerWithEP = '$portUser/api/auth/register-user';
  static const loginWithEP = '$portUser/api/auth/login';

  //Api Blog
  static const reactBlog = '$portBlog/api/reactions';
  static Uri urlGetBlog([Map<String, String>? params]) {
    return Uri.parse('$portBlog/api/blogs').replace(queryParameters: params);
  }

  //Api route
  static Uri urlGetDirectionUsingMapbox(
      MapboxDirectionsRequest mapboxDirectionReq) {
    final coordsString = mapboxDirectionReq.coordinates
        .map((c) => '${c.longitude},${c.latitude}')
        .join(';');

    final uri = Uri.https(
      'api.mapbox.com',
      '/directions/v5/mapbox/${mapboxDirectionReq.profile}/$coordsString',
      {
        'alternatives': mapboxDirectionReq.alternatives.toString(),
        'annotations': mapboxDirectionReq.annotations,
        'continue_straight': mapboxDirectionReq.continueStraight.toString(),
        'geometries': mapboxDirectionReq.geometries,
        'language': mapboxDirectionReq.language,
        'overview': mapboxDirectionReq.overview,
        'steps': mapboxDirectionReq.steps.toString(),
        'access_token': mapboxDirectionReq.accessToken,
      },
    );

    return uri;
  }

  static Uri urlGetEleUsingOpenElevation() {
    return Uri.https("api.open-elevation.com", '/api/v1/lookup');
  }

  static Uri urlGetPlacesAutocomplete(GetPlaceReq request, String apiKey) {
    final queryParams = {
      'api_key': apiKey,
      'input': request.searchText,
    };

    if (request.sessionToken != null && request.sessionToken!.isNotEmpty) {
      queryParams['sessiontoken'] = request.sessionToken!;
    }

    return Uri.https('rsapi.goong.io', '/Place/AutoComplete', queryParams);
  }

  static Uri urlGetPlaceDetail(GetPlaceDetailReq request, String apiKey) {
    final queryParams = {
      'api_key': apiKey,
      'place_id': request.placeId,
    };
    if (request.sessionToken != null && request.sessionToken!.isNotEmpty) {
      queryParams['sessiontoken'] = request.sessionToken!;
    }
    return Uri.https('rsapi.goong.io', '/Place/Detail', queryParams);
  }
}
