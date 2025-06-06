import 'dart:math';

import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/library/bloc/route_filter_cubit.dart';
import 'package:Tracio/presentation/library/widgets/offline_tab.dart';
import 'package:Tracio/presentation/library/widgets/rides_tab.dart';
import 'package:Tracio/presentation/library/widgets/route_tab.dart';
import 'package:Tracio/presentation/library/widgets/saved_tab.dart';
import 'package:Tracio/presentation/map/bloc/get_location_cubit.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  final Map<int, bool> _isMapView = {
    0: false, // Rides
    1: false, // Routes
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  void _toggleViewMode() {
    setState(() {
      _isMapView[_selectedTabIndex] = !(_isMapView[_selectedTabIndex] ?? false);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetLocationCubit(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: _buildAppBar(),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: "Rides"),
                  Tab(text: "Routes"),
                  Tab(text: "Saved"),
                ],
              ),
              BlocListener<RouteCubit, RouteState>(
                listener: (context, state) {
                  if (state is UpdateRouteLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.successMessage),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.read<RouteCubit>().getPlans(null);
                    context.read<RouteCubit>().getRides(null);
                  } else if (state is UpdateRouteFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                    context.read<RouteCubit>().getPlans(null);
                    context.read<RouteCubit>().getRides(null);
                  }
                },
                child: Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      BlocProvider(
                        create: (context) => RouteFilterCubit(),
                        child: RidesTab(),
                      ),
                      BlocProvider(
                        create: (context) => RouteFilterCubit(),
                        child: RouteTab(),
                      ),
                      SavedTab(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
    final isMap = _isMapView[_selectedTabIndex] ?? false;

    switch (_selectedTabIndex) {
      case 0:
      case 1:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(isMap ? Icons.list : Icons.map, color: Colors.white),
              onPressed: _toggleViewMode,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
