import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/bloc/generic_data_cubit.dart';
import 'package:tracio_fe/core/configs/theme/app_theme.dart';
import 'package:tracio_fe/core/signalr_service.dart';
import 'package:tracio_fe/domain/user/entities/user_profile_entity.dart';
import 'package:tracio_fe/domain/user/usecase/get_user_profile.dart';
import 'package:tracio_fe/firebase_options.dart';
import 'package:tracio_fe/presentation/auth/bloc/authCubit/auth_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/comment/get_comment_cubit.dart';
import 'package:tracio_fe/presentation/splash/bloc/splash_cubit.dart';
import 'package:tracio_fe/presentation/splash/page/splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:tracio_fe/service_locator.dart';

import 'service_locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.grey.shade700,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.initializeDependencies();
  // await sl<SignalRService>().initConnection();
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
  configLoading();
}

Future<void> setup() async {
  await dotenv.load(fileName: ".env");
  mp.MapboxOptions.setAccessToken(dotenv.env['MAPBOX_ACCESS_TOKEN']!);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [  
        BlocProvider(create: (context) => SplashCubit()..appStarted()),
        BlocProvider(create: (context) => AuthCubit()..checkUser()),
        BlocProvider(create: (context) => GetCommentCubit()),
        BlocProvider(create: (context) => GenericDataCubit()),
        BlocProvider(create: (context) => LocationBloc()),
      ],
      child: ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          theme: AppTheme.appTheme,
          debugShowCheckedModeBanner: false,
          home: SplashPage(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = true;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
