import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/widgets/search_location_input.dart';
import 'package:tracio_fe/presentation/map/widgets/search_options.dart';
import 'package:tracio_fe/presentation/map/widgets/search_result.dart';

class SearchLocationPage extends StatefulWidget {
  const SearchLocationPage({super.key});

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetLocationCubit(),
        ),
        BlocProvider(
          create: (context) => MapCubit(),
        )
      ],
      child: SafeArea(
        child: Column(
          children: [SearchLocationInput(), SearchOptions(), SearchResult()],
        ),
      ),
    ));
  }
}
