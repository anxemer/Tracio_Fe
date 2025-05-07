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
import 'package:Tracio/common/bloc/filter_cubit.dart';
import 'package:Tracio/common/bloc/generic_data_cubit.dart';
import 'package:Tracio/core/services/notifications/notification_service.dart';
import 'package:Tracio/core/configs/theme/app_theme.dart';
import 'package:Tracio/core/signalr_service.dart';
import 'package:Tracio/firebase_options.dart';
import 'package:Tracio/presentation/chat/bloc/bloc/conversation_bloc.dart';
import 'package:Tracio/presentation/groups/cubit/group_cubit.dart';
import 'package:Tracio/presentation/library/bloc/reaction/bloc/reaction_bloc.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/blog/bloc/category/get_category_cubit.dart';
import 'package:Tracio/presentation/map/bloc/tracking/bloc/tracking_bloc.dart';
import 'package:Tracio/presentation/profile/bloc/user_profile_cubit.dart';
import 'package:Tracio/presentation/service/bloc/bookingservice/reschedule_booking/cubit/reschedule_booking_cubit.dart';
import 'package:Tracio/presentation/service/bloc/get_booking/get_booking_cubit.dart';
import 'package:Tracio/presentation/service/bloc/service_bloc/get_service_cubit.dart';
import 'package:Tracio/presentation/splash/page/splash.dart';
import 'package:Tracio/presentation/auth/bloc/authCubit/auth_cubit.dart';
import 'package:Tracio/presentation/blog/bloc/comment/get_comment_cubit.dart';
import 'package:Tracio/presentation/splash/bloc/splash_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:Tracio/presentation/theme/bloc/theme_cubit.dart';
import 'data/auth/sources/auth_local_source/auth_local_source.dart';
import 'presentation/groups/cubit/challenge_cubit.dart';
import 'presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'presentation/service/bloc/cart_item_bloc/cart_item_cubit.dart';
import 'presentation/service/bloc/review_booking/cubit/review_booking_cubit.dart';
import 'presentation/service/bloc/service_bloc/review_service_cubit/get_reviewcubit/get_review_cubit.dart';
import 'presentation/shop_owner/bloc/resolve_booking/resolve_booking_cubit.dart';
import 'presentation/shop_owner/bloc/service_management/service_management_cubit.dart';
import 'service_locator.dart' as di;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.grey.shade700,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
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
  // await SignalRService().initConnection();
  await di.initializeDependencies();

  await _requestPermissions();

  await NotificationService.init();

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
  void initState() {
    super.initState();
    _initBackgroundGeolocationState();
  }

  void _initBackgroundGeolocationState() async {
    bg.BackgroundGeolocation.stop();
    await bg.BackgroundGeolocation.removeListeners();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserProfileCubit(),
          ),
          BlocProvider(create: (context) => SplashCubit()..appStarted()),
          BlocProvider(
            create: (context) => ReviewBookingCubit(),
          ),
          BlocProvider(create: (context) => GetReviewCubit()),

          BlocProvider(create: (context) => AuthCubit()),
          BlocProvider(create: (context) => GenericDataCubit()),
          BlocProvider(create: (context) => TrackingBloc()),
          BlocProvider(create: (context) => RouteCubit()),
          BlocProvider(create: (context) => GroupCubit()),
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(create: (context) => CartItemCubit()..getCartitem()),
          BlocProvider(create: (context) => GetServiceCubit()),
          BlocProvider(create: (context) => GetBookingCubit()),
          BlocProvider(create: (context) => ResolveBookingShopCubit()),
          BlocProvider(
              create: (context) => ChallengeCubit()..getChallengeOverview()),

          BlocProvider(
              create: (context) => GetCategoryCubit()..getCategoryService()),
          BlocProvider(
            create: (context) => BookingServiceCubit(),
          ),
          BlocProvider(
            create: (context) => RescheduleBookingCubit(),
          ),
          BlocProvider(
            create: (context) => FilterCubit(),
          ),
          BlocProvider(
            create: (context) => ReactionBloc(),
          ),
          BlocProvider(
            create: (context) => ConversationBloc(),
          ),
          BlocProvider(
            create: (context) => ServiceManagementCubit(),
          ),
          // BlocProvider(create: (context) => AuthCubit()..checkUser())
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
                navigatorObservers: [routeObserver],
              ),
            );
          },
        ));
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
