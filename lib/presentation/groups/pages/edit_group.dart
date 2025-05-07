import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/groups/entities/group.dart';
import 'package:Tracio/presentation/groups/cubit/form_edit_group_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/form_edit_group_state.dart';
import 'package:Tracio/core/configs/utils/validators/group_validator.dart';

class EditGroupScreen extends StatefulWidget {
  final Group group;
  const EditGroupScreen({super.key, required this.group});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> with GroupValidator {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // Initialize the FormEditGroupCubit with default values
    context.read<FormEditGroupCubit>().initForm(
          groupName: widget.group.groupName,
          description: widget.group.description ?? "",
          city: widget.group.city,
          district: widget.group.district,
          maxParticipants: widget.group.maxParticipants,
          isPublic: widget.group.isPublic,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Group')),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocConsumer<FormEditGroupCubit, FormEditGroupState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Form(
              key: _formKey,
              autovalidateMode: state.autovalidateMode,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Group Name TextFormField
                    TextFormField(
                      initialValue: state.groupName,
                      validator: (value) => validateName(value),
                      onChanged: (value) => context
                          .read<FormEditGroupCubit>()
                          .updateGroupName(value),
                      decoration: const InputDecoration(
                        labelText: 'Group Name',
                        hintText: 'Enter your group name',
                        prefixIcon: Icon(Icons.group),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description TextFormField
                    TextFormField(
                      initialValue: state.description,
                      validator: (value) => validateName(value),
                      onChanged: (value) => context
                          .read<FormEditGroupCubit>()
                          .updateDescription(value),
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter a description',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // City TextFormField
                    TextFormField(
                      initialValue: state.city,
                      validator: (value) => validateCity(value),
                      onChanged: (value) =>
                          context.read<FormEditGroupCubit>().updateCity(value),
                      decoration: const InputDecoration(
                        labelText: 'City',
                        hintText: 'Enter the city',
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // District TextFormField
                    TextFormField(
                      initialValue: state.district,
                      validator: (value) => validateDistrict(value),
                      onChanged: (value) => context
                          .read<FormEditGroupCubit>()
                          .updateDistrict(value),
                      decoration: const InputDecoration(
                        labelText: 'District',
                        hintText: 'Enter the district',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Max Participants TextFormField
                    TextFormField(
                      initialValue: state.maxParticipants.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        int? maxParticipants = int.tryParse(value);
                        if (maxParticipants != null) {
                          context
                              .read<FormEditGroupCubit>()
                              .updateMaxParticipants(maxParticipants);
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Max Participants',
                        hintText: 'Enter the max number of participants',
                        prefixIcon: Icon(Icons.people),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Public/Private Toggle
                    SwitchListTile(
                      title: const Text('Is Public'),
                      value: state.isPublic,
                      onChanged: (bool value) {
                        context.read<FormEditGroupCubit>().togglePublic(value);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Submit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        backgroundColor: AppColors.secondBackground,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle form submission
                          print('Form Submitted');
                        } else {
                          // If the form is invalid, trigger autovalidation
                          context
                              .read<FormEditGroupCubit>()
                              .updateAutovalidateMode(AutovalidateMode.always);
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: AppSize.textMedium,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
