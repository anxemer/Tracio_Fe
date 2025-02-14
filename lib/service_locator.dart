import 'package:get_it/get_it.dart';
import 'package:tracio_fe/data/auth/repositories/auth_repositoty_impl.dart';
import 'package:tracio_fe/data/auth/sources/auth_api_service.dart';
import 'package:tracio_fe/data/auth/sources/auth_firebase_service.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';
import 'package:tracio_fe/domain/auth/usecases/check_email_verified.dart';
import 'package:tracio_fe/domain/auth/usecases/login.dart';
import 'package:tracio_fe/domain/auth/usecases/register_with_ep.dart';
import 'package:tracio_fe/domain/auth/usecases/verify_email.dart';

import 'core/network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<DioClient>(DioClient());
  //Services
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  //Repositoríe
  sl.registerSingleton<AuthRepository>(AuthRepositotyImpl());
  //UseCase
  sl.registerSingleton<VerifyEmailUseCase>(VerifyEmailUseCase());
  sl.registerSingleton<CheckEmailVerifiedUseCase>(CheckEmailVerifiedUseCase());
  sl.registerSingleton<RegisterWithEmailAndPassUseCase>(
      RegisterWithEmailAndPassUseCase());
  sl.registerSingleton<LoginUseCase>(LoginUseCase());
}
