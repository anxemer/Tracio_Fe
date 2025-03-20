import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tracio_fe/data/map/models/request/isochrone_req.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_state.dart';
import 'package:tracio_fe/presentation/map/bloc/map_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/map_state.dart';

class SearchLocationOptions extends StatefulWidget {
  const SearchLocationOptions({super.key});

  @override
  State<SearchLocationOptions> createState() => _SearchLocationOptionsState();
}

class _SearchLocationOptionsState extends State<SearchLocationOptions> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final String accessToken = dotenv.get("MAPBOX_ACCESS_TOKEN");
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
    String? errorMessage;
    int minValue = 1; // Minimum allowed value
    int maxValue = (unit == "km") ? 10000 : 60; // Max: 10,000 km or 60 minutes

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // ✅ Allows UI updates within the dialog
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixText: unit,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (errorMessage !=
                      null) // ✅ Additional error message styling
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    String value = controller.text.trim();
                    int? input = int.tryParse(value);

                    if (input == null) {
                      setState(
                          () => errorMessage = "Please enter a valid number.");
                      return;
                    }

                    if (input < minValue || input > maxValue) {
                      setState(() {
                        errorMessage =
                            "Value must be between $minValue and $maxValue $unit.";
                      });
                    } else {
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapCubitState>(builder: (context, mapState) {
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
                      onSubmit: (value) async {
                        final distance = int.parse(value);
                        final position = await Geolocator.getCurrentPosition();
                        if (distance >= 0 && distance <= 20000) {
                          IsochroneReq request = IsochroneReq(
                              lng: position.longitude,
                              lat: position.latitude,
                              contourDistance: distance,
                              denoise: 1,
                              generalize: 500,
                              polygon: true,
                              accessToken: accessToken);
                          Navigator.pop(context, request);
                        }
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
                      onSubmit: (value) async {
                        final time = int.tryParse(value);
                        final position = await Geolocator.getCurrentPosition();
                        if (time != null && time > 0 && time <= 60) {
                          final request = IsochroneReq(
                            lng: position.longitude,
                            lat: position.latitude,
                            contourMinutes: time,
                            accessToken: accessToken,
                          );
                          Navigator.pop(context, request);
                        }
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
