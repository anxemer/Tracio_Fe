import 'package:flutter/material.dart';
import 'package:tracio_fe/presentation/map/pages/search_location.dart';

class TopActionBar extends StatelessWidget {
  const TopActionBar({super.key});

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {},
        ),
        // Search location button
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.7,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 1,
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10)),
            onPressed: () async {
              // Navigate to the style selection page and await the result
              final selectedStyle = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SearchLocationPage()),
              );

              // Handle the selected style
              if (selectedStyle != null) {
                // Update the map style using the selectedStyle
                print(
                    'Selected style: $selectedStyle'); // Replace with your logic
              }
            },
            child: Row(
              children: const [
                Icon(
                  Icons.search,
                  color: Colors.black38,
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'Search location',
                    style: TextStyle(
                        color: Colors.black54, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
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
  }
}
