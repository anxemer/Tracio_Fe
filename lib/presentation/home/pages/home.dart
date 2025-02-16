import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/common/widget/button/floating_button.dart';
import 'package:tracio_fe/common/widget/navbar/navbar.dart';
import 'package:tracio_fe/domain/auth/usecases/logout.dart';
import 'package:tracio_fe/presentation/auth/pages/login.dart';
import 'package:tracio_fe/presentation/blog/widget/new_feed.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../service_locator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  bool _isNavbarVisible = true;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 1), // Trượt xuống khi ẩn
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // Cuộn xuống => Ẩn navbar
      if (_isNavbarVisible) {
        _animationController.forward();
        setState(() {
          _isNavbarVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      // Cuộn lên => Hiện navbar
      if (!_isNavbarVisible) {
        _animationController.reverse();
        setState(() {
          _isNavbarVisible = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

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
      body: NewFeeds(
        scrollController: _scrollController,
      ),
      bottomNavigationBar: SlideTransition(
        position: _slideAnimation,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _isNavbarVisible ? 1.0 : 0.0,
          child: BasicNavbar(
            isNavbarVisible: _isNavbarVisible,
          ),
        ),
      ),
    );
  }
}
