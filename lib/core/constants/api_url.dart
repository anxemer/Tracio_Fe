import 'package:tracio_fe/data/map/models/request/get_place_req.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/data/map/models/request/isochrone_req.dart';
import 'package:tracio_fe/data/map/models/request/mapbox_direction_req.dart';

class ApiUrl {
  //base Url
  static const baseURL = 'https://user.tracio.space/';
  // static const baseURL = 'https://10.10.1.66:';
  // static const baseURL = 'https://10.87.46.103:';
  static const hubUrl = 'http://10.87.46.103:5002/content-hub';
  //port
  static const portUser = '5003';
  static const portBlog = '5002';
  static const portRoute = '5009';
  static const portGroup = '';

  //Api User
  static const registerWithEP = '$portUser/api/auth/register-user';
  static const sendVerifyEmail = '$portUser/api/auth/send-verify-email';
  static const loginWithEP = '$portUser/api/auth/login';
  static const userProfile = '$portUser/api/users';

  //Api Blog
  static const reactBlog = '$portBlog/api/reactions';
  static const unReactBlog = '$portBlog/api/reactions';
  static const getReactBlog = '$portBlog/api/blogs';
  static Uri urlGetBlog([Map<String, String>? params]) {
    return Uri.parse('$portBlog/api/blogs').replace(queryParameters: params);
  }

  static Uri urlReplyComment([Map<String, String>? params]) {
    return Uri.parse('$portBlog/api/replies').replace(queryParameters: params);
  }

  static const createBlog = '$portBlog/api/blogs';
  static const categoryBlog = '$portBlog/categories';
  static const commentBlog = '$portBlog/api/comments';
  static const repCommentBlog = '$portBlog/api/replies';
  static const bookmarkBlog = '$portBlog/api/blogs/bookmarks';
  static const unBookmarkBlog = '$portBlog/api/blogs/bookmarks';
  static Uri urlGetBlogComments(int blogId, [Map<String, String>? params]) {
    return Uri.parse('$portBlog/api/blogs/$blogId/comments')
        .replace(queryParameters: params);
  }

  static Uri urlGetRepComments(int commentId, int pageNumber, int pageSize) {
    return Uri.parse(
        '$portBlog/api/comments/$commentId/replies?pageNumber=$pageNumber&pageSize=$pageSize');
  }

  //Api route

  static Uri urlGetRoutes(GetRouteReq request) {
    return Uri.parse('$portRoute/api/route')
        .replace(queryParameters: request.toMap());
  }

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
      'limit': request.limit!.toInt().toString()
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

  static Uri urlGetIsochroneMapbox(IsochroneReq request) {
    final coordsString = "${request.lng},${request.lat}";

    final uri = Uri.https(
      'api.mapbox.com',
      '/isochrone/v1/mapbox/cycling/$coordsString',
      request.toMap(),
    );

    return uri;
  }

  static const postRoute = '$portRoute/api/route';
  static const locationHubUrl = 'http://localhost:$portRoute/locationHub';

  static Uri urlGetStaticImageMapbox(String accessToken, List<num> start,
      List<num> end, String polylineEncoded) {
    final startNum = '${start[0]},${start[1]}';
    final endNum = '${end[0]},${end[1]}';

    final strokeWidth = 5;
    final strokeColor = 'f44';

    final points = 'pin-s-a+9ed4bd($startNum),pin-s-b+000($endNum)';

    final path = 'path-$strokeWidth+$strokeColor($polylineEncoded)';

    final uri = Uri.https(
      'api.mapbox.com',
      '/styles/v1/mapbox/streets-v12/static/$points,$path/auto/400x700',
      {
        'access_token': accessToken,
      },
    );

    return uri;
  }

  static const urlGetProvinces = 'https://provinces.open-api.vn/api/p/';

  static Uri urlGetDistrictsByProvince(int provinceCode, {int depth = 2}) {
    return Uri.https('provinces.open-api.vn', '/api/p/$provinceCode', {
      'depth': depth.toString(),
    });
  }

  static const postGroup = '$portGroup/api/group';
  static Uri urlGetGroupList([Map<String, String>? params]) {
    return Uri.parse('$portGroup/api/group').replace(queryParameters: params);
  }

  static Uri urlGetGroupDetail(int groupId) {
    return Uri.parse('$portGroup/api/group/$groupId');
  }
}
