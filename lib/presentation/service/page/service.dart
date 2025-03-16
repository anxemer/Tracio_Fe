import 'package:flutter/material.dart';
import 'package:tracio_fe/presentation/service/widget/category_service.dart';
import 'package:tracio_fe/presentation/service/widget/custome_search_bar.dart';

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomeSearchBar(),
            ),
            CategoryService(),
            // ServiceGrid()
          ],
        ),
      ),
    );
  }
}
