import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/configs/utils/validators/group_validator.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/data/map/models/route.dart';
import 'package:tracio_fe/domain/map/entities/route.dart';
import 'package:tracio_fe/presentation/groups/cubit/form_group_activity_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/form_group_activity_state.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_state.dart';
import 'package:tracio_fe/presentation/groups/widgets/activity/activity_route_selection.dart';
import 'package:tracio_fe/presentation/groups/widgets/activity/activity_search_location.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_cubit.dart';
import 'package:tracio_fe/presentation/map/bloc/route_cubit.dart';

class CreateGroupActivity extends StatefulWidget {
  final int groupId;
  const CreateGroupActivity({super.key, required this.groupId});

  @override
  State<CreateGroupActivity> createState() => _CreateGroupActivityState();
}

class _CreateGroupActivityState extends State<CreateGroupActivity>
    with GroupValidator {
  final _formKey = GlobalKey<FormState>();
  bool isDisabled = false;

  @override
  void initState() {
    super.initState();
    context.read<FormGroupActivityCubit>().initForm(
          activityName: '',
          description: '',
          meetingAddress: '',
          meetingLocation: null,
          startDateTime: DateTime.now().add(Duration(hours: 1)),
          routeId: -1,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Activity')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocBuilder<FormGroupActivityCubit, FormGroupActivityState>(
          builder: (context, state) {
            final startDate = state.startDateTime;
            if (state.isFailed) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showFailureSnackBar(state.errorMessage);
              });
            }
            return AbsorbPointer(
              absorbing: isDisabled,
              child: Opacity(
                opacity: isDisabled ? 0.5 : 1.0,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: state.activityName,
                          validator: (val) => validateName(val),
                          onChanged: (val) => context
                              .read<FormGroupActivityCubit>()
                              .updateActivityName(val),
                          decoration: const InputDecoration(
                            labelText: 'Title*',
                            hintText: 'Enter activity title',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Start Date & Time
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: startDate,
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime.now().add(Duration(days: 14)),
                                  );
                                  if (picked != null) {
                                    final newDateTime = DateTime(
                                      picked.year,
                                      picked.month,
                                      picked.day,
                                      startDate.hour,
                                      startDate.minute,
                                    );
                                    context
                                        .read<FormGroupActivityCubit>()
                                        .updateStartDateTime(newDateTime);
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Start Date*',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.primary),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.primary),
                                    ),
                                  ),
                                  child: Text(
                                    '${startDate.toLocal()}'.split(' ')[0],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        TimeOfDay.fromDateTime(startDate),
                                    builder: (context, child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null) {
                                    final newDateTime = DateTime(
                                      startDate.year,
                                      startDate.month,
                                      startDate.day,
                                      picked.hour,
                                      picked.minute,
                                    );
                                    context
                                        .read<FormGroupActivityCubit>()
                                        .updateStartDateTime(newDateTime);
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Start Time*',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.primary),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.primary),
                                    ),
                                  ),
                                  child: Text(
                                    TimeOfDay.fromDateTime(startDate)
                                        .format(context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Text(
                          "Meeting Location",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            showFilterLocationModal(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    state.meetingAddress.isNotEmpty
                                        ? state.meetingAddress
                                        : 'Select meeting location',
                                    style: TextStyle(
                                      color: state.meetingAddress.isNotEmpty
                                          ? Colors.black
                                          : Colors.grey.shade500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          "Route",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () async {
                            final GetRouteReq request = GetRouteReq(
                                pageNumber: 1, rowsPerPage: 10, sortAsc: false);
                            context.read<RouteCubit>().getRoutes(request);
                            final result = await Navigator.push<RouteEntity>(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BlocProvider<
                                            FormGroupActivityCubit>.value(
                                          value: BlocProvider.of<
                                              FormGroupActivityCubit>(context),
                                          child: ActivityRouteSelection(),
                                        )));

                            if (result != null) {
                              context
                                  .read<FormGroupActivityCubit>()
                                  .updateRouteId(result);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    state.routeEntity != null
                                        ? "${state.routeEntity!.routeName} - ${state.routeEntity!.city}"
                                        : 'Select a Route',
                                    style: TextStyle(
                                      color: state.routeId > -1
                                          ? Colors.black
                                          : Colors.grey.shade500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          "Select a Route...",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: AppSize.textSmall.sp),
                        ),

                        const SizedBox(height: 16),

                        // Description
                        TextFormField(
                          initialValue: state.description,
                          maxLines: 3,
                          onChanged: (val) => context
                              .read<FormGroupActivityCubit>()
                              .updateDescription(val),
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'Enter activity description',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.secondBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.secondBackground, width: 1),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              hoverColor:
                                  AppColors.darkGrey.withValues(alpha: 0.1),
                              splashColor:
                                  AppColors.darkGrey.withValues(alpha: 0.1),
                              highlightColor:
                                  AppColors.darkGrey.withValues(alpha: 0.1),
                              onTap: () async {
                                FocusScope.of(context).unfocus();

                                final dateTimeError =
                                    validateDateTime(state.startDateTime);

                                if (_formKey.currentState!.validate() &&
                                    dateTimeError == null) {
                                  await context
                                      .read<FormGroupActivityCubit>()
                                      .submitCreateGroupActivity(
                                          widget.groupId);
                                  setState(() {});
                                } else if (dateTimeError != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(dateTimeError)),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSize.apVerticalPadding,
                                ),
                                child: Center(
                                    child: state.isLoading == false
                                        ? Text(
                                            'Create Activity',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : SizedBox(
                                            width: 24.w,
                                            height: 24.h,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showFilterLocationModal(BuildContext context) {
    showModalBottomSheet(
      anchorPoint: Offset(0, 0),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (modalContext) {
        return BlocProvider(
          create: (context) => GetLocationCubit(),
          child: BlocProvider<FormGroupActivityCubit>.value(
            value: BlocProvider.of<FormGroupActivityCubit>(context),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.85,
              builder: (_, scrollController) {
                return ActivitySearchLocation(
                    bottomSheetContext: modalContext,
                    scrollController: scrollController);
              },
            ),
          ),
        );
      },
    );
  }

  void _showFailureSnackBar(String errorMessage) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Something went wrong, please try later!\n$errorMessage'),
        ),
      );
    }
  }
}
