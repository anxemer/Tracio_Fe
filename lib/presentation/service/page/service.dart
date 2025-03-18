import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/presentation/service/widget/category_service.dart';
import 'package:tracio_fe/presentation/service/widget/custome_search_bar.dart';
import 'package:tracio_fe/presentation/service/widget/near_location.dart';
import 'package:tracio_fe/presentation/service/widget/service_grid.dart'
    show ServiceGrid;

import '../../../core/constants/app_size.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // appBar: AppBar(
      //   leading: CustomeSearchBar(),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            CustomeSearchBar(),
            CategoryService(),
            
            ServiceGrid()
          ],
        ),
      ),
    );
  }
}
