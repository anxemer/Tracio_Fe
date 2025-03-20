import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/library/bloc/route_filter_cubit.dart';
import 'package:tracio_fe/presentation/library/widgets/offline_tab.dart';
import 'package:tracio_fe/presentation/library/widgets/rides_tab.dart';
import 'package:tracio_fe/presentation/library/widgets/route_tab.dart';
import 'package:tracio_fe/presentation/library/widgets/saved_tab.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RouteFilterCubit()),
        BlocProvider(create: (context) => GetLocationCubit()),
      ],
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: _buildAppBar(),
          body: Column(
            children: [
              const TabBar(
                labelColor: Colors.black,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(text: "Rides"),
                  Tab(text: "Routes"),
                  Tab(text: "Saved"),
                  Tab(text: "Offline"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [RidesTab(), RouteTab(), SavedTab(), OfflineTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//TODO: Build app bar
  PreferredSizeWidget _buildAppBar() {
    return BasicAppbar(
      hideBack: false,
      action: _buildAppbarAction(),
      title: Text(
        'Library',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: AppSize.textHeading * 0.9.sp,
        ),
      ),
    );
  }

  Widget _buildAppbarAction() {
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.search),
    );
  }
}
