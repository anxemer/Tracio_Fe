import 'package:Tracio/data/map/models/request/get_place_req.dart';
import 'package:Tracio/data/map/models/request/get_route_req.dart';
import 'package:Tracio/data/map/models/request/isochrone_req.dart';
import 'package:Tracio/data/map/models/request/mapbox_direction_req.dart';

class ApiUrl {
  //base Url
  // static const baseURL = 'https://192.168.1.9:';
  // static const baseURL = 'https://user.Tracio.space';
  static const baseURL = 'https://api.tracio.space';
  static const hubUrl = 'http://103.28.33.123:5002/content-hub';
  static const groupRouteHubUrl = 'http://103.28.33.123:5009/locationHub';
  static const chatHubUrl = 'http://103.28.33.123:5005/chat-hub';
  static const notiHubUrl = 'http://103.28.33.123:5006/notification-hub';
  //port
  // static const portUser = '5003';
  static const notiPort = 'https://noti.tracio.space';
  static const portUser = '';
  static const portBlog = '';
  static const portRoute = '';
  static const portGroup = '';
  static const portShop = '';
  static const portChat = '';
  static const sendFcm = '$notiPort/api/fcm';
  //Api User
  static const registerWithEP = '$portUser/api/auth/register-user';
  static const loginGoogle = '$portUser/api/auth/login-google';
  static const callbackGoogle = '$portUser/api/auth/auth/google-callback';
  static const sendVerifyEmail = '$portUser/api/auth/send-verify-email';
  static const loginWithEP = '$portUser/api/auth/login';
  static const userProfile = '$portUser/api/users';
  static const follow = '$portUser/api/follow';
  static const changeRole = '$portUser/api/auth/refresh-token';
  static const registerShop = '$portUser/api/users/shop-profile';
  static const editShop = '$portShop/api/shops';
  static const dailyActivity = '$portShop/api/users/cycling-activities';

  //Api Blog
  static const reactBlog = '$portBlog/api/reactions';
  static const unReactBlog = '$portBlog/api/reactions';
  static const getReactBlog = '$portBlog/api/blogs';
  static Uri urlGetBlog([Map<String, String>? params]) {
    return Uri.parse('$portBlog/api/blogs').replace(queryParameters: params);
  }

  static Uri urlGetBookMarkBlog([Map<String, String>? params]) {
    return Uri.parse('$portBlog/api/blogs/bookmarks')
        .replace(queryParameters: params);
  }

  static Uri urlReplyComment([Map<String, String>? params]) {
    return Uri.parse('$portBlog/api/replies').replace(queryParameters: params);
  }

  static const createBlog = '$portBlog/api/blogs';
  static const categoryBlog = '$portBlog/api/blogs/categories';
  static const commentBlog = '$portBlog/api/comments';
  static const repCommentBlog = '$portBlog/api/content-replies';
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
        .replace(queryParameters: request.toQueryParams());
  }

  static String urlCustomMapTile =
      "mapbox://styles/trminloc/cm7brl3yq006m01qyhqlx2kze";

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
        'banner_instructions': mapboxDirectionReq.bannerInstructions.toString()
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

  //Api Shop service
  static Uri urlGetService([Map<String, String>? params]) {
    return Uri.parse('$portShop/api/services').replace(queryParameters: params);
  }

  static Uri urlGetDetailService(int serviceId, [Map<String, String>? params]) {
    return Uri.parse('$portShop/api/services/$serviceId/service-details')
        .replace(queryParameters: params);
  }

  static Uri urlGetReviewService(int serviceId, [Map<String, String>? params]) {
    return Uri.parse('$portShop/api/services/$serviceId/reviews')
        .replace(queryParameters: params);
  }

  static Uri urlGetBooking([Map<String, String>? params]) {
    return Uri.parse('$portShop/api/bookings').replace(queryParameters: params);
  }

  static const apiService = '$portShop/api/services';
  static const addToCart = '$portShop/api/carts';
  static const getCartItem = '$portShop/api/carts/items';
  static const getCateService = '$portShop/api/categories';
  static const bookingService = '$portShop/api/bookings';
  static const deleteCartItem = '$portShop/api/carts';
  static const getShopProfile = '$portShop/api/shops/profile';
  static const reviewBooking = '$portShop/api/reviews';
  static const replyReview = '$portShop/api/replies';
  // static const submitBooking = '${portShop}/api/carts';
  static const rescheduleBooking = '$portShop/api/bookings/reschedule-booking';

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
  static const startTracking = '$portRoute/api/route/start';
  static const finishTracking = '$portRoute/api/route/finish';
  static Uri urlGetGroupList([Map<String, String>? params]) {
    return Uri.parse('$portGroup/api/group').replace(queryParameters: params);
  }

  static Uri urlGetGroupDetail(int groupId) {
    return Uri.parse('$portGroup/api/group/$groupId');
  }

  //Challenge Api
  static const getChallengeOverview = '$portUser/api/challenge/overview';
  static const apiChallenge = '$portUser/api/challenge';
  static const requestChallenge =
      '$portUser/api/challenge/update-status-public';
  // static const apiChallengeReward = '$portUser/api/challenge-reward';
  static Uri apiChallengeReward([Map<String, String>? params]) {
    return Uri.parse('$portUser/api/challenge-reward')
        .replace(queryParameters: params);
  }

  static Uri urlPostGroupRoute(int groupId) {
    return Uri.parse('$portGroup/api/group/$groupId/route');
  }

  static Uri urlGetGroupRoute(int groupId, [Map<String, String>? params]) {
    return Uri.parse('$portGroup/api/group/$groupId/route')
        .replace(queryParameters: params);
  }

  static Uri urlGetParticipants(int groupId, [Map<String, String>? params]) {
    return Uri.parse('$portGroup/api/group/$groupId/participant')
        .replace(queryParameters: params);
  }

  static String urlUpdateGroup = "$portGroup/api/group";
  static String urlDeleteGroup = "$portGroup/api/group";
  static Uri urlAssignRoleGroupOwner(int groupId, int targetUserId) {
    return Uri.parse(
        "$portGroup/api/group/$groupId/participant/$targetUserId/role");
  }

  static Uri urlRemoveParticipant(int groupId, int targetUserId) {
    return Uri.parse("$portGroup/api/group/$groupId/participant/$targetUserId");
  }

  static Uri urlLeaveGroup(int groupId) {
    return Uri.parse("$portGroup/api/group/$groupId/participant/leave");
  }

  static Uri urlDeleteGroupRoute(int groupId, int groupRouteId) {
    return Uri.parse("$portGroup/api/group/$groupId/route/$groupRouteId");
  }

  static Uri urlUpdateGroupRoute(int groupId, int groupRouteId) {
    return Uri.parse("$portGroup/api/group/$groupId/route/$groupRouteId");
  }

  static Uri urlGetGroupRouteDetail(int groupRouteId,
      [Map<String, String>? params]) {
    return Uri.parse("$portGroup/api/group/route/$groupRouteId")
        .replace(queryParameters: params);
  }

  static Uri urlSendInvitation(int groupId) {
    return Uri.parse("$portGroup/api/group/$groupId/invitation/send");
  }

  static Uri urlRequestToJoinGroup(int groupId) {
    return Uri.parse("$portGroup/api/group/$groupId/invitation/request");
  }

  static Uri urlAcceptInvitation(int invitationId) {
    return Uri.parse("$portGroup/api/invitation/$invitationId/response");
  }

  static Uri urlAcceptRequestToJoinGroup(int invitationId) {
    return Uri.parse(
        "$portGroup/api/invitation/$invitationId/response-to-request");
  }

  static Uri urlGetGroupInvitation(int groupId, [Map<String, String>? params]) {
    return Uri.parse("$portGroup/api/group/$groupId/invitation")
        .replace(queryParameters: params);
  }

  static Uri urlGetMyInvitationAndRequest([Map<String, String>? params]) {
    return Uri.parse("$portGroup/api/me/invitation/sent/group")
        .replace(queryParameters: params);
  }

  static Uri urlDeleteMyInvitationAndRequest(int invitationId) {
    return Uri.parse("$portGroup/api/invitation/$invitationId");
  }

  static Uri urlGetRouteDetail(int routeId) {
    return Uri.parse("$portRoute/api/route/$routeId");
  }

  static Uri urlGetRouteBlogList([Map<String, String>? params]) {
    return Uri.parse("$portRoute/api/route/blog")
        .replace(queryParameters: params);
  }

  static Uri urlGetRouteBlogReviews(int routeId,
      [Map<String, String>? params]) {
    return Uri.parse("$portRoute/api/route-reviews/route/$routeId")
        .replace(queryParameters: params);
  }

  static Uri urlGetRouteReviewReplies = Uri.parse("$portRoute/api/replies");
  static Uri urlPostRouteReview = Uri.parse("$portRoute/api/reviews");
  static Uri urlPostRouteReply = Uri.parse("$portRoute/api/replies");

  static Uri urlDeleteRouteReview(
    int reviewId,
  ) {
    return Uri.parse("$portRoute/api/reviews/$reviewId");
  }

  static Uri urlDeleteRouteReply(
    int replyId,
  ) {
    return Uri.parse("$portRoute/api/replies/$replyId");
  }

  static Uri urlRouteReaction(
    int routeId,
  ) {
    return Uri.parse("$portRoute/api/reactions/route/$routeId");
  }

  static Uri urlReviewReaction(
    int reviewId,
  ) {
    return Uri.parse("$portRoute/api/reactions/review/$reviewId");
  }

  static Uri urlReplyReaction(
    int replyId,
  ) {
    return Uri.parse("$portRoute/api/reactions/reply/$replyId");
  }

  static Uri urlGetConversations([Map<String, String>? params]) {
    return Uri.parse("$portChat/api/conversations")
        .replace(queryParameters: params);
  }

  static Uri urlGetMessages(Map<String, String>? params) {
    return Uri.parse("$portChat/api/messages").replace(queryParameters: params);
  }

  static Uri urlPostMessages = Uri.parse("$portChat/api/messages");
  static Uri urlPostConversation = Uri.parse("$portChat/api/conversations");
  static Uri urlGetConversationByGroupId(int groupId) {
    return Uri.parse("$portChat/api/conversations/$groupId/conversation");
  }
}
