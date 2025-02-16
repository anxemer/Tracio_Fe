import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/common/widget/button/floating_button.dart';
import 'package:tracio_fe/common/widget/navbar/navbar.dart';
import 'package:tracio_fe/domain/auth/usecases/logout.dart';
import 'package:tracio_fe/presentation/auth/pages/login.dart';
import 'package:tracio_fe/presentation/blog/widget/new_feed.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../service_locator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
          height: 100.h,
          hideBack: false,
          title: Text(
            'Home',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40.sp),
          ),
          action: Row(
            children: [
              FloatingButton(
                elevation: 1,
                backgroundColor: Colors.white,
                onPressed: () {},
                action: Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.black,
                ),
              ),
              FloatingButton(
                elevation: 1,
                backgroundColor: Colors.white,
                onPressed: () {},
                action: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.black,
                ),
              ),
              FloatingButton(
                elevation: 1,
                backgroundColor: Colors.white,
                onPressed: () async {
                  var data = await sl<LogoutUseCase>().call();

                  AppNavigator.pushReplacement(context, LoginPage());
                },
                action: Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          )),
      body: NewFeeds(),
      bottomNavigationBar: BasicNavbar(),
    );
  }
}
