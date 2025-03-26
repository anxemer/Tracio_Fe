import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracio_fe/common/helper/notification/noti_service.dart';
import 'package:tracio_fe/common/bloc/generic_data_cubit.dart';
import 'package:tracio_fe/core/configs/theme/app_theme.dart';
import 'package:tracio_fe/firebase_options.dart';
import 'package:tracio_fe/presentation/blog/bloc/category/get_category_cubit.dart';
import 'package:tracio_fe/presentation/splash/page/splash.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_bloc.dart';
import 'package:tracio_fe/presentation/auth/bloc/authCubit/auth_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/comment/get_comment_cubit.dart';
import 'package:tracio_fe/presentation/splash/bloc/splash_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:tracio_fe/presentation/theme/bloc/theme_cubit.dart';

import 'presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'presentation/service/bloc/cart_item_bloc/cart_item_cubit.dart';
import 'service_locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.grey.shade700,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await dotenv.load(fileName: ".env");
    mp.MapboxOptions.setAccessToken(dotenv.env['MAPBOX_ACCESS_TOKEN']!);
  } catch (e) {
    debugPrint("⚠️ Failed to load .env file: $e");
  }

  await di.initializeDependencies();

  await _requestPermissions();

  await NotiService().initNotification();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  runApp(const MyApp());
  configLoading();
}

/// ✅ Request necessary permissions
Future<void> _requestPermissions() async {
  await [
    Permission.locationAlways,
    Permission.storage,
    Permission.accessNotificationPolicy,
    Permission.notification,
    Permission.activityRecognition
  ].request();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashCubit()..appStarted()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => GetCommentCubit()),
        BlocProvider(create: (context) => GenericDataCubit()),
        BlocProvider(create: (context) => LocationBloc()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => CartItemCubit()..getCartitem()),
        BlocProvider(
          create: (context) => BookingServiceCubit(),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp(
              theme: AppTheme.appLightTheme,
              darkTheme: AppTheme.appDarkTheme,
              themeMode: state,
              debugShowCheckedModeBanner: false,
              home: SplashPage(),
              builder: EasyLoading.init(),
            ),
          );
        },
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
