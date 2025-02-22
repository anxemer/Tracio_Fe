import 'package:get_it/get_it.dart';
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
import 'package:tracio_fe/domain/blog/usecase/craete_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/get_blogs.dart';
import 'package:tracio_fe/domain/blog/usecase/get_category.dart';
import 'package:tracio_fe/domain/blog/usecase/react_blog.dart';

import 'core/network/dio_client.dart';
import 'domain/blog/usecase/un_react_blog.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<DioClient>(DioClient());
  //Services
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  sl.registerSingleton<BlogApiService>(BlogApiServiceImpl());
  //Repositoríe
  sl.registerSingleton<AuthRepository>(AuthRepositotyImpl());
  sl.registerSingleton<BlogRepository>(BlogRepositoryImpl());
  //UseCase
  sl.registerSingleton<VerifyEmailUseCase>(VerifyEmailUseCase());
  sl.registerSingleton<CheckEmailVerifiedUseCase>(CheckEmailVerifiedUseCase());
  sl.registerSingleton<RegisterWithEmailAndPassUseCase>(
      RegisterWithEmailAndPassUseCase());
  sl.registerSingleton<LoginUseCase>(LoginUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());
  sl.registerSingleton<GetBlogsUseCase>(GetBlogsUseCase());
  sl.registerSingleton<ReactBlogUseCase>(ReactBlogUseCase());
  sl.registerSingleton<UnReactBlogUseCase>(UnReactBlogUseCase());
  sl.registerSingleton<CreateBlogUseCase>(CreateBlogUseCase());
  sl.registerSingleton<GetCategoryUseCase>(GetCategoryUseCase());
}
