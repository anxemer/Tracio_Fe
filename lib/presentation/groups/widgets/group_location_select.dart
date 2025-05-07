import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/bloc/generic_data_cubit.dart';
import 'package:Tracio/common/bloc/generic_data_state.dart';
import 'package:Tracio/common/widget/drag_handle/drag_handle.dart';
import 'package:Tracio/data/groups/models/response/vietnam_city_model.dart';
import 'package:Tracio/data/groups/models/response/vietnam_district_model.dart';
import 'package:Tracio/domain/groups/usecases/get_district_usecase.dart';
import 'package:Tracio/presentation/groups/cubit/form_group_cubit.dart';
import 'package:Tracio/service_locator.dart';

class GroupLocationSelect extends StatefulWidget {
  final FormGroupCubit cubit;
  const GroupLocationSelect({super.key, required this.cubit});

  @override
  State<GroupLocationSelect> createState() => _GroupLocationSelectState();
}

class _GroupLocationSelectState extends State<GroupLocationSelect> {
  VietnamCityModel? selectedCity;
  VietnamDistrictModel? selectedDistrict;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: DragHandle(height: 6, color: Colors.grey.shade400)),
          const SizedBox(
            height: 8.0,
          ),
          const Text("City", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          BlocBuilder<GenericDataCubit, GenericDataState>(
            builder: (context, state) {
              return Autocomplete<VietnamCityModel>(
                displayStringForOption: (option) => option.name,
                optionsBuilder: (TextEditingValue cityTextEditingValue) {
                  if (cityTextEditingValue.text == '') {
                    return const Iterable<VietnamCityModel>.empty();
                  }

                  return state is DataLoaded<List<VietnamCityModel>>
                      ? state.data.where((VietnamCityModel option) {
                          return option.name.toLowerCase().contains(
                              cityTextEditingValue.text.toLowerCase());
                        })
                      : const Iterable<VietnamCityModel>.empty();
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: "Select city",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black87)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black38)),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  );
                },
                onSelected: (VietnamCityModel value) {
                  setState(() {
                    selectedCity = value;
                  });

                  Future.microtask(() {
                    context.read<GenericDataCubit>().getData<VietnamCityModel>(
                          sl<GetDistrictUsecase>(),
                          params: value.code,
                        );
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),

          const Text("District", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          BlocBuilder<GenericDataCubit, GenericDataState>(
            builder: (context, state) {
              List<DropdownMenuItem<VietnamDistrictModel>> items = [];

              if (selectedCity != null) {
                if (state is DataLoaded &&
                    state.data is VietnamCityModel &&
                    (state.data as VietnamCityModel).districts.isNotEmpty) {
                  final districts = (state.data as VietnamCityModel).districts;
                  items = districts.map((district) {
                    return DropdownMenuItem<VietnamDistrictModel>(
                      value: district,
                      child: Text(district.name),
                    );
                  }).toList();
                }
              }

              return DropdownButtonFormField<VietnamDistrictModel>(
                menuMaxHeight: 200.h,
                value: selectedDistrict,
                onChanged: selectedCity != null
                    ? (value) {
                        setState(() {
                          selectedDistrict = value;
                        });
                      }
                    : null,
                decoration: InputDecoration(
                  hintText: "Select district",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 1, color: Colors.black87)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 1, color: Colors.black38)),
                ),
                items: items,
              );
            },
          ),
          const SizedBox(height: 24),

          // Use Current Location
          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context, {"useCurrentLocation": true});
              },
              icon: const Icon(Icons.my_location),
              label: const Text("Use My Current Location"),
            ),
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); // cancel
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: selectedCity != null && selectedDistrict != null
                    ? () {
                        widget.cubit.updateDistrictCity(
                            selectedCity!.name, selectedDistrict!.name);
                        widget.cubit.validateStep(2);
                        Navigator.pop(context, {
                          "city": selectedCity,
                          "district": selectedDistrict,
                        });
                      }
                    : null,
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
