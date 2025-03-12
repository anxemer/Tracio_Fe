import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/common/bloc/generic_data_cubit.dart';
import 'package:tracio_fe/common/widget/navbar/navbar.dart';
import 'package:tracio_fe/presentation/blog/bloc/comment/get_commnet_cubit.dart';
import 'package:tracio_fe/presentation/blog/pages/blog.dart';

import '../../../data/blog/models/request/get_blog_req.dart';
import '../../blog/bloc/create_blog_cubit.dart';
import '../../blog/bloc/get_blog_cubit.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GenericDataCubit(),
        ),
        BlocProvider(
          create: (context) => GetBlogCubit()..getBlog(GetBlogReq()),
        ),
        BlocProvider(
          create: (context) => CreateBlogCubit(),
        ),
        BlocProvider(
          create: (context) => GetCommentCubit(),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: BlogPage(
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
        ),
      ),
    );
  }
}
