import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_state.dart';

class SearchOptions extends StatefulWidget {
  const SearchOptions({super.key});

  @override
  State<SearchOptions> createState() => _SearchOptionsState();
}

class _SearchOptionsState extends State<SearchOptions> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  @override
  void dispose() {
    _distanceController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _showInputDialog({
    required String title,
    required TextEditingController controller,
    required String unit,
    required Function(String value) onSubmit,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixText: unit,
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String value = controller.text.trim();
                if (value.isNotEmpty) {
                  onSubmit(value);
                  Navigator.pop(context);
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetLocationCubit, GetLocationState>(
        builder: (context, state) {
      if (state is GetLocationInitial) {
        return Padding(
          padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationOption(
                icon: Icons.my_location,
                text: "Choose Current Location",
                onTap: () {
                  const searchedCoordinate = "Current Location Coordinates";
                  Navigator.pop(context, searchedCoordinate);
                },
              ),
              const Divider(
                  thickness: 1, color: Colors.grey), // Horizontal Divider
              _buildLocationOption(
                icon: Icons.home,
                text: "Set Your Home Location",
                onTap: () {
                  const searchedCoordinate = "Home Location Coordinates";
                  Navigator.pop(context, searchedCoordinate);
                },
              ),

              const Divider(
                  thickness: 1, color: Colors.grey), // Horizontal Divider
              _buildLocationOption(
                icon: Icons.directions_bike,
                text: "Search by Cycling Distance",
                onTap: () {
                  _showInputDialog(
                    title: "Enter Cycling Distance",
                    controller: _distanceController,
                    unit: "km",
                    onSubmit: (value) {
                      final distance = double.parse(value);
                      Navigator.pop(context, "Cycling Distance: $distance km");
                    },
                  );
                },
              ),
              const Divider(thickness: 1, color: Colors.grey),

              _buildLocationOption(
                icon: Icons.timer,
                text: "Search by Cycling Time",
                onTap: () {
                  _showInputDialog(
                    title: "Enter Cycling Time",
                    controller: _timeController,
                    unit: "minutes",
                    onSubmit: (value) {
                      final time = int.parse(value);
                      Navigator.pop(context, "Cycling Time: $time minutes");
                    },
                  );
                },
              ),
            ],
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Widget _buildLocationOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 24),
            SizedBox(width: 12),
            Text(text),
          ],
        ),
      ),
    );
  }
}
