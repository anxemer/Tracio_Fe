import 'package:tracio_fe/data/map/models/get_place_req.dart';
import 'package:tracio_fe/data/map/models/isochrone_req.dart';
import 'package:tracio_fe/data/map/models/mapbox_direction_req.dart';

class ApiUrl {
  //base Url
  // static const baseURL = 'https://192.168.1.9:';
  static const baseURL = 'http://103.28.33.123:';
  // static const baseURL = 'https://10.87.46.103:';
  static const hubUrl = 'http://10.87.46.103:5002/content-hub';
  //port
  static const portUser = '5003';
  static const portBlog = '5002';
  static const portRoute = '5009';
  static const portShop = '5004';

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

  //Api Shop service
  static Uri urlGetService([Map<String, String>? params]) {
    return Uri.parse('$portShop/api/services').replace(queryParameters: params);
  }

  static Uri urlGetBooking([Map<String, String>? params]) {
    return Uri.parse('$portShop/api/bookings').replace(queryParameters: params);
  }

  static const getService = '${portShop}/api/services';
  static const addToCart = '${portShop}/api/carts';
  static const getCartItem = '${portShop}/api/carts/items';
  static const getCateService = '${portShop}/api/categories';
  static const bookingService = '${portShop}/api/bookings';
  static const getBooking = '${portShop}/api/bookings';
}
