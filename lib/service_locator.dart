import 'package:Tracio/core/services/location/location_service.dart';
import 'package:Tracio/core/services/signalR/implement/notification_hub_service.dart';
import 'package:Tracio/data/blog/repositories/blog_repository_impl.dart';
import 'package:Tracio/data/challenge/models/request/create_challenge_req.dart';
import 'package:Tracio/domain/blog/usecase/edit_blog.dart';
import 'package:Tracio/domain/challenge/usecase/create_challenge.dart';
import 'package:Tracio/domain/challenge/usecase/get_user_reward.dart';
import 'package:Tracio/domain/groups/usecases/update_group_route_status_usecase.dart';
import 'package:Tracio/domain/map/usecase/delete_route_media_usecase.dart';
import 'package:Tracio/domain/map/usecase/delete_route_usecase.dart';
import 'package:Tracio/domain/map/usecase/edit_route_tracking_usecase.dart';
import 'package:Tracio/domain/map/usecase/get_ongoing_route_usecase.dart';
import 'package:Tracio/domain/map/usecase/get_route_media_usecase.dart';
import 'package:Tracio/domain/map/usecase/post_route_media_usecase.dart';
import 'package:Tracio/domain/challenge/usecase/request_challenge.dart';
import 'package:Tracio/domain/user/usecase/edit_profile.dart';
import 'package:Tracio/domain/user/usecase/get_daily_activity.dart';
import 'package:Tracio/domain/user/usecase/get_follow_request.dart';
import 'package:Tracio/domain/user/usecase/resolve_follow_request.dart';
import 'package:Tracio/domain/user/usecase/unfollow_user..dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Tracio/core/network/network_infor.dart';
import 'package:Tracio/core/services/signalR/implement/chat_hub_service.dart';
import 'package:Tracio/core/services/signalR/implement/group_route_hub_service.dart';
import 'package:Tracio/core/services/signalR/implement/matching_hub_service.dart';
import 'package:Tracio/core/services/signalR/signalr_core_service.dart';
import 'package:Tracio/core/signalr_service.dart';
import 'package:Tracio/data/auth/repositories/auth_repositoty_impl.dart';
import 'package:Tracio/data/auth/sources/auth_remote_source/auth_api_service.dart';
import 'package:Tracio/data/auth/sources/auth_remote_source/auth_firebase_service.dart';
import 'package:Tracio/data/blog/repositories/blog_repository_impl.dart';
import 'package:Tracio/data/blog/source/blog_api_service.dart';
import 'package:Tracio/data/chat/repositories/chat_repository_impl.dart';
import 'package:Tracio/data/chat/source/chat_api_service.dart';
import 'package:Tracio/data/challenge/repository/challenge_repository_impl.dart';
import 'package:Tracio/data/challenge/source/challenge_api_service.dart';
import 'package:Tracio/data/groups/repositories/group_repository_impl.dart';
import 'package:Tracio/data/groups/repositories/invitation_repository_impl.dart';
import 'package:Tracio/data/groups/repositories/vietnam_city_district_repository_impl.dart';
import 'package:Tracio/data/groups/source/group_api_service.dart';
import 'package:Tracio/data/groups/source/invitation_api_service.dart';
import 'package:Tracio/data/groups/source/vietnam_city_district_service.dart';
import 'package:Tracio/data/map/repositories/elevation_repository_impl.dart';
import 'package:Tracio/data/map/repositories/image_repository_impl.dart';
import 'package:Tracio/data/map/repositories/location_repository_impl.dart';
import 'package:Tracio/data/map/repositories/reaction_repository_impl.dart';
import 'package:Tracio/data/map/repositories/route_repository_impl.dart';
import 'package:Tracio/data/map/source/elevation_api_service.dart';
import 'package:Tracio/data/map/source/image_url_api_service.dart';
import 'package:Tracio/data/map/source/location_api_service.dart';
import 'package:Tracio/data/map/source/reaction_api_service.dart';
import 'package:Tracio/data/map/source/route_api_service.dart';
import 'package:Tracio/data/map/source/tracking_grpc_service.dart';
import 'package:Tracio/data/map/source/tracking_hub_service.dart';
import 'package:Tracio/data/shop/repositories/shop_service_repository_impl.dart';
import 'package:Tracio/data/shop/source/shop_api_service.dart';
import 'package:Tracio/data/user/repositories/user_profile_repository_impl.dart';
import 'package:Tracio/data/user/source/user_api_source.dart';
import 'package:Tracio/domain/auth/repositories/auth_repository.dart';
import 'package:Tracio/domain/auth/usecases/change_role.dart';
import 'package:Tracio/domain/auth/usecases/check_email_verified.dart';
import 'package:Tracio/domain/blog/usecase/get_bookmark_blog.dart';
import 'package:Tracio/domain/chat/usecases/get_shop_messages_usecase.dart';
import 'package:Tracio/domain/shop/usecase/edit_shop.dart';
import 'package:Tracio/domain/shop/usecase/get_review_booking.dart';
import 'package:Tracio/domain/shop/usecase/get_shop_profile.dart';
import 'package:Tracio/domain/auth/usecases/get_cacher_user.dart';
import 'package:Tracio/domain/auth/usecases/is_logged_in.dart';
import 'package:Tracio/domain/auth/usecases/login.dart';
import 'package:Tracio/domain/auth/usecases/login_google.dart';
import 'package:Tracio/domain/auth/usecases/logout.dart';
import 'package:Tracio/domain/auth/usecases/register_with_ep.dart';
import 'package:Tracio/domain/auth/usecases/verify_email.dart';
import 'package:Tracio/domain/blog/repositories/blog_repository.dart';
import 'package:Tracio/domain/blog/usecase/bookmark_blog.dart';
import 'package:Tracio/domain/blog/usecase/comment_blog.dart';
import 'package:Tracio/domain/blog/usecase/craete_blog.dart';
import 'package:Tracio/domain/blog/usecase/get_blogs.dart';
import 'package:Tracio/domain/blog/usecase/get_category.dart';
import 'package:Tracio/domain/blog/usecase/get_comment_blog.dart';
import 'package:Tracio/domain/blog/usecase/get_reaction_blog.dart';
import 'package:Tracio/domain/blog/usecase/get_reply_comment.dart';
import 'package:Tracio/domain/blog/usecase/react_blog.dart';
import 'package:Tracio/domain/chat/repositories/chat_repository.dart';
import 'package:Tracio/domain/chat/usecases/get_conversations_usecase.dart';
import 'package:Tracio/domain/chat/usecases/get_messages_usecase.dart';
import 'package:Tracio/domain/chat/usecases/post_message_usecase.dart';
import 'package:Tracio/domain/challenge/repository/challenge_repository.dart';
import 'package:Tracio/domain/challenge/usecase/get_challenge_detail.dart';
import 'package:Tracio/domain/challenge/usecase/get_challenge_overview.dart';
import 'package:Tracio/domain/challenge/usecase/get_participants.dart';
import 'package:Tracio/domain/challenge/usecase/join_challenge.dart';
import 'package:Tracio/domain/groups/repositories/group_repository.dart';
import 'package:Tracio/domain/groups/repositories/invitation_repository.dart';
import 'package:Tracio/domain/groups/repositories/vietnam_city_district_repository.dart';
import 'package:Tracio/domain/groups/usecases/get_city_usecase.dart';
import 'package:Tracio/domain/groups/usecases/get_district_usecase.dart';
import 'package:Tracio/domain/groups/usecases/get_group_detail_usecase.dart';
import 'package:Tracio/domain/groups/usecases/get_group_list_usecase.dart';
import 'package:Tracio/domain/groups/usecases/get_group_route_detail_usecase.dart';
import 'package:Tracio/domain/groups/usecases/get_group_route_usecase.dart';
import 'package:Tracio/domain/groups/usecases/get_participant_list_usecase.dart';
import 'package:Tracio/domain/groups/usecases/invitations/accept_group_invitation_usecase.dart';
import 'package:Tracio/domain/groups/usecases/invitations/invite_user_usecase.dart';
import 'package:Tracio/domain/groups/usecases/invitations/request_to_join_group_usecase.dart';
import 'package:Tracio/domain/groups/usecases/invitations/response_join_group_request_usecase.dart';
import 'package:Tracio/domain/groups/usecases/leave_group_usecase.dart';
import 'package:Tracio/domain/groups/usecases/post_group_route_usecase.dart';
import 'package:Tracio/domain/groups/usecases/post_group_usecase.dart';
import 'package:Tracio/domain/map/repositories/elevation_repository.dart';
import 'package:Tracio/domain/map/repositories/image_repository.dart';
import 'package:Tracio/domain/map/repositories/location_repository.dart';
import 'package:Tracio/domain/map/repositories/reaction_repository.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/domain/map/usecase/finish_tracking_usecase.dart';
import 'package:Tracio/domain/map/usecase/get_direction_using_mapbox.dart';
import 'package:Tracio/domain/map/usecase/get_elevation.dart';
import 'package:Tracio/domain/map/usecase/get_image_url_usecase.dart';
import 'package:Tracio/domain/map/usecase/get_location_detail.dart';
import 'package:Tracio/domain/map/usecase/get_locations.dart';
import 'package:Tracio/domain/map/usecase/get_route_detail_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/delete_reaction_reply_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/delete_reaction_review_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/delete_reaction_route_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/get_reaction_reply_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/get_reaction_review_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/get_reaction_route_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/post_reaction_reply_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/post_reaction_review_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/post_reaction_route_usecase.dart';
import 'package:Tracio/domain/map/usecase/route_blog/delete_reply_usecase.dart';
import 'package:Tracio/domain/map/usecase/route_blog/delete_review_usecase.dart';
import 'package:Tracio/domain/map/usecase/route_blog/get_route_blog_list_usecase.dart';
import 'package:Tracio/domain/map/usecase/route_blog/get_route_blog_reviews_usecase.dart';
import 'package:Tracio/domain/map/usecase/route_blog/get_route_replies_usecase.dart';
import 'package:Tracio/domain/map/usecase/get_routes.dart';
import 'package:Tracio/domain/map/usecase/post_route.dart';
import 'package:Tracio/domain/blog/usecase/unBookmark.dart';
import 'package:Tracio/domain/map/usecase/route_blog/post_reply_usecase.dart';
import 'package:Tracio/domain/map/usecase/route_blog/post_review_usecase.dart';
import 'package:Tracio/domain/map/usecase/start_tracking_usecase.dart';
import 'package:Tracio/domain/shop/repositories/shop_service_repository.dart';
import 'package:Tracio/domain/shop/usecase/add_to_cart.dart';
import 'package:Tracio/domain/shop/usecase/booking_service.dart';
import 'package:Tracio/domain/shop/usecase/cancel_booking.dart';
import 'package:Tracio/domain/shop/usecase/complete_booking.dart';
import 'package:Tracio/domain/shop/usecase/create_service.dart';
import 'package:Tracio/domain/shop/usecase/delete_cart_item.dart';
import 'package:Tracio/domain/shop/usecase/delete_service.dart';
import 'package:Tracio/domain/shop/usecase/get_booking.dart';
import 'package:Tracio/domain/shop/usecase/get_booking_detail.dart';
import 'package:Tracio/domain/shop/usecase/get_cart_item.dart';
import 'package:Tracio/domain/shop/usecase/get_cate_service.dart';
import 'package:Tracio/domain/shop/usecase/get_review_service.dart';
import 'package:Tracio/domain/shop/usecase/get_service.dart';
import 'package:Tracio/domain/shop/usecase/get_service_detail.dart';
import 'package:Tracio/domain/shop/usecase/register_shop_profile.dart';
import 'package:Tracio/domain/shop/usecase/reply_review.dart';
import 'package:Tracio/domain/shop/usecase/reschedule_booking.dart';
import 'package:Tracio/domain/shop/usecase/process_booking.dart';
import 'package:Tracio/domain/shop/usecase/confirm_booking.dart';
import 'package:Tracio/domain/shop/usecase/review_booking.dart';
import 'package:Tracio/domain/user/repositories/user_profile_repository.dart';
import 'package:Tracio/domain/user/usecase/follow_user.dart';
import 'package:Tracio/domain/user/usecase/get_user_profile.dart';

import 'core/network/dio_client.dart';
import 'data/auth/sources/auth_local_source/auth_local_source.dart';
import 'domain/blog/usecase/rep_comment.dart';
import 'domain/blog/usecase/un_react_blog.dart';
import 'domain/challenge/usecase/leave_challenge.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<DioClient>(DioClient());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton(sharedPreferences);

  // * SERVICES
  sl.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfor>(() => NetworkInforIml(sl()));
  // Remote services
  sl.registerLazySingleton<AuthFirebaseService>(
      () => AuthFirebaseServiceImpl());
  sl.registerLazySingleton<AuthApiService>(() => AuthApiServiceImpl());
  sl.registerLazySingleton<BlogApiService>(() => BlogApiServiceImpl());
  sl.registerLazySingleton<AuthLocalSource>(() => AuthLocalSourceImp());
  sl.registerLazySingleton<UserApiSource>(() => UserApiSourceImpl());
  sl.registerLazySingleton<RouteApiService>(() => RouteApiServiceImpl());
  sl.registerLazySingleton<ElevationApiService>(
      () => ElevationApiServiceImpl());
  sl.registerLazySingleton<LocationApiService>(() => LocationApiServiceImpl());
  sl.registerLazySingleton<VietnamCityDistrictService>(
      () => VietnamCityDistrictServiceImpl());
  sl.registerLazySingleton<GroupApiService>(() => GroupApiServiceImpl());
  sl.registerLazySingleton<ShopApiService>(() => ShopApiServiceImpl());
  sl.registerLazySingleton<ChallengeApiService>(
      () => ChallengeApiServiceImpl());
  sl.registerLazySingleton<ShopServiceRepository>(
      () => ShopServiceRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ImageUrlApiService>(() => ImageUrlApiServiceImpl());
  sl.registerLazySingleton<InvitationApiService>(
      () => InvitationApiServiceImpl());
  sl.registerLazySingleton<ReactionApiService>(() => ReactionApiServiceImpl());
  sl.registerLazySingleton<ChatApiService>(() => ChatApiServiceImpl());
  // * REPOSITORIES
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositotyImpl());
  sl.registerLazySingleton<BlogRepository>(
      () => BlogRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<UserProfileRepository>(
      () => UserProfileRepositoryImpl(dataSource: sl()));
  sl.registerLazySingleton<RouteRepository>(() => RouteRepositoryImpl());
  sl.registerLazySingleton<ElevationRepository>(
      () => ElevationRepositoryImpl());
  sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl());
  sl.registerLazySingleton<VietnamCityDistrictRepository>(
      () => VietnamCityDistrictRepositoryImpl());
  sl.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl());
  sl.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl());
  sl.registerLazySingleton<InvitationRepository>(
      () => InvitationRepositoryImpl());
  sl.registerLazySingleton<ReactionRepository>(() => ReactionRepositoryImpl());
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl());
  sl.registerLazySingleton<ChallengeRepository>(
      () => ChallengeRepositoryImpl(remoteDataSource: sl()));
  // * gRPC & Hubs
  sl.registerLazySingleton(() => SignalRCoreService());
  sl.registerLazySingleton<ITrackingGrpcService>(
    () => TrackingGrpcService(),
  );
  sl.registerLazySingleton<ITrackingHubService>(() => TrackingHubService());
  sl.registerLazySingleton<LocationService>(() => LocationService());

  //when hub services is depended on SignalRCoreService
  sl.registerLazySingleton(
      () => GroupRouteHubService(sl<SignalRCoreService>()));
  sl.registerLazySingleton(() => ChatHubService(sl<SignalRCoreService>()));
  sl.registerLazySingleton(() => MatchingHubService(sl<SignalRCoreService>()));
  sl.registerLazySingleton(
      () => NotificationHubService(sl<SignalRCoreService>()));
  // * USECASES--use registerFactory
  sl.registerFactory<GetBlogsUseCase>(() => GetBlogsUseCase());
  sl.registerFactory<GetBookmarkBlogsUseCase>(() => GetBookmarkBlogsUseCase());
  sl.registerFactory<GetReactBlogUseCase>(() => GetReactBlogUseCase());
  sl.registerFactory<ReactBlogUseCase>(() => ReactBlogUseCase());
  sl.registerFactory<UnReactBlogUseCase>(() => UnReactBlogUseCase());
  sl.registerFactory<CreateBlogUseCase>(() => CreateBlogUseCase());
  sl.registerFactory<GetCategoryUseCase>(() => GetCategoryUseCase());
  sl.registerFactory<GetCommentBlogUseCase>(() => GetCommentBlogUseCase());
  sl.registerFactory<CommentBlogUsecase>(() => CommentBlogUsecase());
  sl.registerFactory<VerifyEmailUseCase>(() => VerifyEmailUseCase());
  sl.registerFactory<CheckEmailVerifiedUseCase>(
      () => CheckEmailVerifiedUseCase());
  sl.registerFactory<RegisterWithEmailAndPassUseCase>(
      () => RegisterWithEmailAndPassUseCase());
  sl.registerFactory<LoginUseCase>(() => LoginUseCase());
  sl.registerFactory<ChangeRoleUseCase>(() => ChangeRoleUseCase());
  sl.registerFactory<IsLoggedInUseCase>(() => IsLoggedInUseCase());
  sl.registerFactory<LogoutUseCase>(() => LogoutUseCase());
  sl.registerFactory<BookmarkBlogUseCase>(() => BookmarkBlogUseCase());
  sl.registerFactory<UnBookmarkUseCase>(() => UnBookmarkUseCase());
  sl.registerFactory<GetReplyCommentUsecase>(() => GetReplyCommentUsecase());
  sl.registerFactory<RepCommentUsecase>(() => RepCommentUsecase());
  sl.registerFactory<GetUserProfileUseCase>(() => GetUserProfileUseCase());
  sl.registerFactory<GetCacherUserUseCase>(() => GetCacherUserUseCase());
  sl.registerFactory<GetDirectionUsingMapboxUseCase>(
      () => GetDirectionUsingMapboxUseCase());
  sl.registerFactory<GetElevationUseCase>(() => GetElevationUseCase());
  sl.registerFactory<GetLocationAutoCompleteUseCase>(
      () => GetLocationAutoCompleteUseCase());
  sl.registerFactory<GetLocationDetailUseCase>(
      () => GetLocationDetailUseCase());
  sl.registerFactory<PostRouteUseCase>(() => PostRouteUseCase());
  sl.registerFactory<GetRoutesUseCase>(() => GetRoutesUseCase());
  sl.registerFactory<GetDistrictUsecase>(() => GetDistrictUsecase());
  sl.registerFactory<GetCityUsecase>(() => GetCityUsecase());
  sl.registerFactory<PostGroupUsecase>(() => PostGroupUsecase());
  sl.registerFactory<GetGroupDetailUsecase>(() => GetGroupDetailUsecase());
  sl.registerFactory<GetGroupListUsecase>(() => GetGroupListUsecase());
  sl.registerFactory<GetServiceUseCase>(() => GetServiceUseCase());
  sl.registerFactory<AddToCartUseCase>(() => AddToCartUseCase());
  sl.registerFactory<GetCartItemUseCase>(() => GetCartItemUseCase());
  sl.registerFactory<GetCateServiceUseCase>(() => GetCateServiceUseCase());
  sl.registerFactory<BookingServiceUseCase>(() => BookingServiceUseCase());
  sl.registerFactory<GetBookingUseCase>(() => GetBookingUseCase());
  sl.registerFactory<DeleteCartItemUseCase>(() => DeleteCartItemUseCase());
  sl.registerFactory<PostGroupRouteUsecase>(() => PostGroupRouteUsecase());
  sl.registerFactory<GetImageUrlUsecase>(() => GetImageUrlUsecase());
  sl.registerFactory<GetGroupRouteUsecase>(() => GetGroupRouteUsecase());
  sl.registerFactory<GetParticipantListUsecase>(
      () => GetParticipantListUsecase());
  sl.registerFactory<RequestToJoinGroupUsecase>(
      () => RequestToJoinGroupUsecase());
  sl.registerFactory<AcceptGroupInvitationUsecase>(
      () => AcceptGroupInvitationUsecase());
  sl.registerFactory<ResponseJoinGroupRequestUsecase>(
      () => ResponseJoinGroupRequestUsecase());
  sl.registerFactory<InviteUserUsecase>(() => InviteUserUsecase());
  sl.registerFactory<LeaveGroupUsecase>(() => LeaveGroupUsecase());
  sl.registerFactory<StartTrackingUsecase>(() => StartTrackingUsecase());
  sl.registerFactory<FinishTrackingUsecase>(() => FinishTrackingUsecase());
  sl.registerFactory<GetRouteDetailUsecase>(() => GetRouteDetailUsecase());
  sl.registerFactory<GetGroupRouteDetailUsecase>(
      () => GetGroupRouteDetailUsecase());
  sl.registerFactory<GetRouteBlogListUsecase>(() => GetRouteBlogListUsecase());
  sl.registerFactory<GetRouteBlogReviewsUsecase>(
      () => GetRouteBlogReviewsUsecase());
  sl.registerFactory<GetRouteRepliesUsecase>(() => GetRouteRepliesUsecase());
  sl.registerFactory<PostReplyUsecase>(() => PostReplyUsecase());
  sl.registerFactory<PostReviewUsecase>(() => PostReviewUsecase());
  sl.registerFactory<DeleteReviewUsecase>(() => DeleteReviewUsecase());
  sl.registerFactory<DeleteReplyUsecase>(() => DeleteReplyUsecase());
  sl.registerFactory<DeleteReactionReplyUsecase>(
      () => DeleteReactionReplyUsecase());
  sl.registerFactory<DeleteReactionReviewUsecase>(
      () => DeleteReactionReviewUsecase());
  sl.registerFactory<DeleteReactionRouteUsecase>(
      () => DeleteReactionRouteUsecase());
  sl.registerFactory<GetReactionReplyUsecase>(() => GetReactionReplyUsecase());
  sl.registerFactory<GetReactionReviewUsecase>(
      () => GetReactionReviewUsecase());
  sl.registerFactory<GetReactionRouteUsecase>(() => GetReactionRouteUsecase());
  sl.registerFactory<PostReactionReplyUsecase>(
      () => PostReactionReplyUsecase());
  sl.registerFactory<PostReactionReviewUsecase>(
      () => PostReactionReviewUsecase());
  sl.registerFactory<PostReactionRouteUsecase>(
      () => PostReactionRouteUsecase());
  sl.registerFactory<GetMessagesUsecase>(() => GetMessagesUsecase());
  sl.registerFactory<GetConversationsUsecase>(() => GetConversationsUsecase());
  sl.registerFactory<PostMessageUsecase>(() => PostMessageUsecase());
  sl.registerFactory<ProcessBookingUseCase>(() => ProcessBookingUseCase());
  sl.registerFactory<RescheduleBookingUseCase>(
      () => RescheduleBookingUseCase());
  sl.registerFactory<CancelBookingUseCase>(() => CancelBookingUseCase());
  sl.registerFactory<GetBookingDetailUseCase>(() => GetBookingDetailUseCase());
  sl.registerFactory<ConfirmBookingUseCase>(() => ConfirmBookingUseCase());
  sl.registerFactory<CompleteBookingUseCase>(() => CompleteBookingUseCase());
  sl.registerFactory<GetReviewServiceUseCase>(() => GetReviewServiceUseCase());
  sl.registerFactory<GetShopProfileUseCase>(() => GetShopProfileUseCase());
  sl.registerFactory<ReviewBookingUseCase>(() => ReviewBookingUseCase());
  sl.registerFactory<CreateServiceUseCase>(() => CreateServiceUseCase());
  sl.registerFactory<GetServiceDetailUseCase>(() => GetServiceDetailUseCase());
  sl.registerFactory<DeleteServiceUseCase>(() => DeleteServiceUseCase());
  sl.registerFactory<GetChallengeOverviewUseCase>(
      () => GetChallengeOverviewUseCase());
  sl.registerFactory<GetChallengeDetailUseCase>(
      () => GetChallengeDetailUseCase());
  sl.registerFactory<JoinChallengeUseCase>(() => JoinChallengeUseCase());
  sl.registerFactory<GetParticipantsUseCase>(() => GetParticipantsUseCase());
  sl.registerFactory<LoginGoogleUseCase>(() => LoginGoogleUseCase());
  sl.registerFactory<FollowUserUseCase>(() => FollowUserUseCase());
  sl.registerFactory<UnFollowUserUseCase>(() => UnFollowUserUseCase());
  sl.registerFactory<GetReviewBookingUseCase>(() => GetReviewBookingUseCase());
  sl.registerFactory<ReplyReviewUseCase>(() => ReplyReviewUseCase());
  sl.registerFactory<RegisterShopUseCase>(() => RegisterShopUseCase());
  sl.registerFactory<EditShopUseCase>(() => EditShopUseCase());
  sl.registerFactory<GetShopMessagesUsecase>(() => GetShopMessagesUsecase());
  sl.registerFactory<PostRouteMediaUsecase>(() => PostRouteMediaUsecase());
  sl.registerFactory<GetRouteMediaUsecase>(() => GetRouteMediaUsecase());
  sl.registerFactory<DeleteRouteMediaUsecase>(() => DeleteRouteMediaUsecase());
  sl.registerFactory<EditRouteTrackingUsecase>(
      () => EditRouteTrackingUsecase());
  sl.registerFactory<GetOngoingRouteUsecase>(() => GetOngoingRouteUsecase());
  sl.registerFactory<UpdateGroupRouteStatusUsecase>(
      () => UpdateGroupRouteStatusUsecase());

  await sl.allReady();
  sl.registerFactory<EditBlogUseCase>(() => EditBlogUseCase());
  sl.registerFactory<EditUserProfileUseCase>(() => EditUserProfileUseCase());
  sl.registerFactory<GetDailyActivityUseCase>(() => GetDailyActivityUseCase());
  sl.registerFactory<GetFollowRequestUseCase>(() => GetFollowRequestUseCase());
  sl.registerFactory<ResolveFollowUserUseCase>(
      () => ResolveFollowUserUseCase());
  sl.registerFactory<RequestChallengeUseCase>(() => RequestChallengeUseCase());
  sl.registerFactory<DeleteRouteUsecase>(() => DeleteRouteUsecase());
}
