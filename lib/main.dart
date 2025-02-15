import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:tracio_fe/core/configs/theme/app_theme.dart';
import 'package:tracio_fe/presentation/map/pages/map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Error loading .env file: $e");
  }
  await setup();
  runApp(const MyApp());
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
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MaterialApp(
        title: 'Tracio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: child,
      ),
      child: const MapPage(),
    );
  }
}
