import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/common/widget/button/floating_button.dart';
import 'package:tracio_fe/common/widget/navbar/navbar.dart';
import 'package:tracio_fe/presentation/home/widgets/post_blog.dart';

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
                onPressed: () {},
                action: Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          )),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => PostBlog(),
                  childCount: 5)),
        ],
      ),
      bottomNavigationBar: BasicNavbar(),
    );
  }
}
