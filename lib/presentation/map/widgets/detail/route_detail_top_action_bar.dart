import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/map_state.dart';

class RouteDetailTopActionBar extends StatelessWidget {
  const RouteDetailTopActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapCubitState>(builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          //Options button
          IconButton(
            style: IconButton.styleFrom(
                elevation: 2,
                shadowColor: Colors.black54,
                backgroundColor: Colors.white,
                alignment: Alignment.center,
                padding: EdgeInsets.zero),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          //Options button
          //TODO: Popup menu
          IconButton(
            style: IconButton.styleFrom(
                elevation: 2,
                shadowColor: Colors.black54,
                backgroundColor: Colors.white,
                alignment: Alignment.center,
                padding: EdgeInsets.zero),
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black54,
            ),
            onPressed: () {},
          ),
        ],
      );
    });
  }
}
