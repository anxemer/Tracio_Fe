import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracio_fe/core/network/network_infor.dart';
import 'package:tracio_fe/core/signalr_service.dart';
import 'package:tracio_fe/data/auth/repositories/auth_repositoty_impl.dart';
import 'package:tracio_fe/data/auth/sources/auth_remote_source/auth_api_service.dart';
import 'package:tracio_fe/data/auth/sources/auth_remote_source/auth_firebase_service.dart';
import 'package:tracio_fe/data/blog/repositories/blog_repository_impl.dart';
import 'package:tracio_fe/data/blog/source/blog_api_service.dart';
import 'package:tracio_fe/data/challenge/repository/challenge_repository_impl.dart';
import 'package:tracio_fe/data/challenge/source/challenge_api_service.dart';
import 'package:tracio_fe/data/groups/repositories/group_repository_impl.dart';
import 'package:tracio_fe/data/groups/repositories/vietnam_city_district_repository_impl.dart';
import 'package:tracio_fe/data/groups/source/group_api_service.dart';
import 'package:tracio_fe/data/groups/source/vietnam_city_district_service.dart';
import 'package:tracio_fe/data/map/repositories/elevation_repository_impl.dart';
import 'package:tracio_fe/data/map/repositories/location_repository_impl.dart';
import 'package:tracio_fe/data/map/repositories/route_repository_impl.dart';
import 'package:tracio_fe/data/map/source/elevation_api_service.dart';
import 'package:tracio_fe/data/map/source/location_api_service.dart';
import 'package:tracio_fe/data/map/source/route_api_service.dart';
import 'package:tracio_fe/data/map/source/tracking_grpc_service.dart';
import 'package:tracio_fe/data/map/source/tracking_hub_service.dart';
import 'package:tracio_fe/data/shop/repositories/shop_service_repository_impl.dart';
import 'package:tracio_fe/data/shop/source/shop_api_service.dart';
import 'package:tracio_fe/data/user/repositories/user_profile_repository_impl.dart';
import 'package:tracio_fe/data/user/source/user_api_source.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';
import 'package:tracio_fe/domain/auth/usecases/change_role.dart';
import 'package:tracio_fe/domain/auth/usecases/check_email_verified.dart';
import 'package:tracio_fe/domain/shop/usecase/get_shop_profile.dart';
import 'package:tracio_fe/domain/auth/usecases/get_cacher_user.dart';
import 'package:tracio_fe/domain/auth/usecases/is_logged_in.dart';
import 'package:tracio_fe/domain/auth/usecases/login.dart';
import 'package:tracio_fe/domain/auth/usecases/login_google.dart';
import 'package:tracio_fe/domain/auth/usecases/login.dart';
import 'package:tracio_fe/domain/auth/usecases/logout.dart';
import 'package:tracio_fe/domain/auth/usecases/register_with_ep.dart';
import 'package:tracio_fe/domain/auth/usecases/verify_email.dart';
import 'package:tracio_fe/domain/blog/repositories/blog_repository.dart';
import 'package:tracio_fe/domain/blog/usecase/bookmark_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/comment_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/craete_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/get_blogs.dart';
import 'package:tracio_fe/domain/blog/usecase/get_category.dart';
import 'package:tracio_fe/domain/blog/usecase/get_comment_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/get_reaction_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/get_reply_comment.dart';
import 'package:tracio_fe/domain/blog/usecase/react_blog.dart';
import 'package:tracio_fe/domain/challenge/repository/challenge_repositories.dart';
import 'package:tracio_fe/domain/challenge/usecase/get_challenge_detail.dart';
import 'package:tracio_fe/domain/challenge/usecase/get_challenge_overview.dart';
import 'package:tracio_fe/domain/challenge/usecase/get_participants.dart';
import 'package:tracio_fe/domain/challenge/usecase/join_challenge.dart';
import 'package:tracio_fe/domain/groups/repositories/group_repository.dart';
import 'package:tracio_fe/domain/groups/repositories/vietnam_city_district_repository.dart';
import 'package:tracio_fe/domain/groups/usecases/get_city_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/get_district_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/get_group_detail_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/get_group_list_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/post_group_usecase.dart';
import 'package:tracio_fe/domain/map/repositories/elevation_repository.dart';
import 'package:tracio_fe/domain/map/repositories/location_repository.dart';
import 'package:tracio_fe/domain/map/repositories/route_repository.dart';
import 'package:tracio_fe/domain/map/usecase/get_direction_using_mapbox.dart';
import 'package:tracio_fe/domain/map/usecase/get_elevation.dart';
import 'package:tracio_fe/domain/map/usecase/get_location_detail.dart';
import 'package:tracio_fe/domain/map/usecase/get_locations.dart';
import 'package:tracio_fe/domain/map/usecase/get_routes.dart';
import 'package:tracio_fe/domain/map/usecase/post_route.dart';
import 'package:tracio_fe/domain/blog/usecase/unBookmark.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';
import 'package:tracio_fe/domain/shop/usecase/add_to_cart.dart';
import 'package:tracio_fe/domain/shop/usecase/booking_service.dart';
import 'package:tracio_fe/domain/shop/usecase/cancel_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/complete_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/create_service.dart';
import 'package:tracio_fe/domain/shop/usecase/delete_cart_item.dart';
import 'package:tracio_fe/domain/shop/usecase/delete_service.dart';
import 'package:tracio_fe/domain/shop/usecase/get_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/get_booking_detail.dart';
import 'package:tracio_fe/domain/shop/usecase/get_cart_item.dart';
import 'package:tracio_fe/domain/shop/usecase/get_cate_service.dart';
import 'package:tracio_fe/domain/shop/usecase/get_review_service.dart';
import 'package:tracio_fe/domain/shop/usecase/get_service.dart';
import 'package:tracio_fe/domain/shop/usecase/get_service_detail.dart';
import 'package:tracio_fe/domain/shop/usecase/reschedule_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/process_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/confirm_booking.dart';
import 'package:tracio_fe/domain/shop/usecase/review_booking.dart';
import 'package:tracio_fe/domain/user/repositories/user_profile_repository.dart';
import 'package:tracio_fe/domain/user/usecase/get_user_profile.dart';

import 'core/network/dio_client.dart';
import 'data/auth/sources/auth_local_source/auth_local_source.dart';
import 'domain/blog/usecase/rep_comment.dart';
import 'domain/blog/usecase/un_react_blog.dart';

// Tối ưu dependency injection
final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core services - những thứ cần thiết ngay lập tức
  sl.registerSingleton<DioClient>(DioClient());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton(sharedPreferences);

  // Các service cơ bản - đăng ký lazy để tạo khi cần
  sl.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfor>(() => NetworkInforIml(sl()));
  // Remote services
  sl.registerLazySingleton<AuthFirebaseService>(
      () => AuthFirebaseServiceImpl());
  sl.registerLazySingleton<AuthApiService>(() => AuthApiServiceImpl());
  sl.registerLazySingleton<BlogApiService>(() => BlogApiServiceImpl());
  sl.registerLazySingleton<AuthLocalSource>(() => AuthLocalSourceImp());
  sl.registerLazySingleton<SignalRService>(() => SignalRService());
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
  //Services
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositotyImpl());
  sl.registerLazySingleton<UserProfileRepository>(
      () => UserProfileRepositoryImpl(dataSource: sl()));

  sl.registerLazySingleton<BlogRepository>(() => BlogRepositoryImpl(
      networkInfo: sl(), remoteDataSource: sl(), signalRService: sl()));
  sl.registerLazySingleton<RouteRepository>(() => RouteRepositoryImpl());
  sl.registerLazySingleton<ElevationRepository>(
      () => ElevationRepositoryImpl());
  sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl());
  sl.registerLazySingleton<VietnamCityDistrictRepository>(
      () => VietnamCityDistrictRepositoryImpl());
  sl.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl());

  sl.registerLazySingleton<ShopServiceRepository>(
      () => ShopServiceRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ChallengeRepositories>(
      () => ChallengeRepositoryImpl(remoteDataSource: sl()));
  //gRPC & Hubs
  sl.registerLazySingleton<ITrackingGrpcService>(() => TrackingGrpcService());
  sl.registerLazySingleton<ITrackingHubService>(() => TrackingHubService());
  // Use cases - thường không cần là singleton vì không giữ state
  // Có thể sử dụng registerFactory nếu không cần lưu trữ state
  sl.registerFactory<GetBlogsUseCase>(() => GetBlogsUseCase());
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
}
