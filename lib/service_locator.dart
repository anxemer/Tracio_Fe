import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracio_fe/core/network/network_infor.dart';
import 'package:tracio_fe/core/signalr_service.dart';
import 'package:tracio_fe/data/auth/repositories/auth_repositoty_impl.dart';
import 'package:tracio_fe/data/auth/sources/auth_remote_source/auth_api_service.dart';
import 'package:tracio_fe/data/auth/sources/auth_remote_source/auth_firebase_service.dart';
import 'package:tracio_fe/data/blog/repositories/blog_repository_impl.dart';
import 'package:tracio_fe/data/blog/source/blog_api_service.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';
import 'package:tracio_fe/domain/auth/usecases/check_email_verified.dart';
import 'package:tracio_fe/domain/auth/usecases/is_logged_in.dart';
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
import 'package:tracio_fe/domain/blog/usecase/unBookmark.dart';

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

  // Repositories - sử dụng constructor injection
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositotyImpl());

  sl.registerLazySingleton<BlogRepository>(
      () => BlogRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()));

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

  // Auth use cases
  sl.registerFactory<VerifyEmailUseCase>(() => VerifyEmailUseCase());
  sl.registerFactory<CheckEmailVerifiedUseCase>(
      () => CheckEmailVerifiedUseCase());
  sl.registerFactory<RegisterWithEmailAndPassUseCase>(
      () => RegisterWithEmailAndPassUseCase());
  sl.registerFactory<LoginUseCase>(() => LoginUseCase());
  sl.registerFactory<IsLoggedInUseCase>(() => IsLoggedInUseCase());
  sl.registerFactory<LogoutUseCase>(() => LogoutUseCase());
  sl.registerFactory<BookmarkBlogUseCase>(() => BookmarkBlogUseCase());
  sl.registerFactory<UnBookmarkUseCase>(() => UnBookmarkUseCase());
  sl.registerFactory<GetReplyCommentUsecase>(() => GetReplyCommentUsecase());
  sl.registerFactory<RepCommentUsecase>(() => RepCommentUsecase());
}
