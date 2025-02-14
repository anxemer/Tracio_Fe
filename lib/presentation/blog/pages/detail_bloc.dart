import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widget/appbar/app_bar.dart';
import '../../../common/widget/button/floating_button.dart';

class DetailBlocPage extends StatefulWidget {
  const DetailBlocPage({super.key});

  @override
  State<DetailBlocPage> createState() => _DetailBlocPageState();
}

class _DetailBlocPageState extends State<DetailBlocPage> {
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
        ),
      ),
      body: Container(
        
      ),
    );
  }
}
