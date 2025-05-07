import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/groups/models/request/post_group_req.dart';
import 'package:Tracio/presentation/groups/cubit/form_group_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/group_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/group_state.dart';
import 'package:Tracio/presentation/groups/cubit/invitation_bloc.dart';
import 'package:Tracio/presentation/groups/pages/group_detail.dart';
import 'package:Tracio/presentation/groups/widgets/group_info_step.dart';
import 'package:Tracio/presentation/groups/widgets/group_location_step.dart';
import 'package:Tracio/presentation/groups/widgets/group_privacy_step.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  int currentStep = 0;

  @override
  void initState() {
    context.read<GroupCubit>().refreshState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.light(primary: AppColors.secondBackground)),
        child: BlocProvider(
          create: (context) => FormGroupCubit()..validateStep(0),
          child: BlocBuilder<FormGroupCubit, FormGroupState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: Stepper(
                      type: StepperType.horizontal,
                      steps: getSteps(state),
                      currentStep: currentStep,
                      onStepContinue: () {
                        final isLastStep =
                            currentStep == getSteps(state).length - 1;
                        if (isLastStep && state.canSubmit) {
                          PostGroupReq request =
                              context.read<FormGroupCubit>().toPostGroupReq();
                          context.read<GroupCubit>().postGroup(request);
                        } else if (!isLastStep && state.canNext) {
                          setState(() {
                            currentStep += 1;
                          });
                          context
                              .read<FormGroupCubit>()
                              .validateStep(currentStep);
                        }
                      },
                      onStepCancel: currentStep == 0
                          ? null
                          : () {
                              setState(() {
                                currentStep -= 1;
                              });
                              context
                                  .read<FormGroupCubit>()
                                  .validateStep(currentStep);
                            },
                      controlsBuilder: (context, controlsDetails) {
                        final isLastStep =
                            currentStep == getSteps(state).length - 1;
                        final isEnabled =
                            isLastStep ? state.canSubmit : state.canNext;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: controlsDetails.onStepCancel,
                              child: Text(currentStep != 0 ? 'Back' : 'Cancel'),
                            ),
                            BlocConsumer<GroupCubit, GroupState>(
                              listener: (context, state) {
                                if (state is GroupFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.errorMessage),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else if (state is PostGroupSuccess) {
                                  if (state.isSuccess) {
                                    AppNavigator.push(
                                        context,
                                        BlocProvider.value(
                                          value:
                                              BlocProvider.of<InvitationBloc>(
                                                  context),
                                          child: GroupDetailScreen(
                                            groupId: state.groupId,
                                          ),
                                        ));
                                  }
                                }
                              },
                              builder: (context, state) {
                                bool isButtonEnabled = (state is GroupInitial ||
                                        state is GroupFailure) &&
                                    isEnabled;

                                return ElevatedButton(
                                  onPressed: isButtonEnabled
                                      ? controlsDetails.onStepContinue
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppSize.apHorizontalPadding * 2,
                                      vertical: AppSize.apVerticalPadding / 2,
                                    ),
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: state is GroupLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text(
                                          isLastStep
                                              ? 'Create Group'
                                              : 'Continue',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                );
                              },
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Step> getSteps(FormGroupState state) => [
        Step(
          isActive: currentStep >= 0,
          title: const SizedBox.shrink(),
          content: GroupInfoStep(),
          state: _getStepState(0, state),
        ),
        Step(
          isActive: currentStep >= 1,
          title: const SizedBox.shrink(),
          content: GroupPrivacyStep(),
          state: _getStepState(1, state),
        ),
        Step(
          isActive: currentStep >= 2,
          title: const SizedBox.shrink(),
          content: GroupLocationStep(),
          state: _getStepState(2, state),
        ),
      ];

  StepState _getStepState(int step, FormGroupState state) {
    if (step < currentStep) return StepState.complete;
    if (step == currentStep) {
      if (step == 2) {
        return state.canSubmit ? StepState.editing : StepState.error;
      }
      return state.canNext ? StepState.editing : StepState.error;
    }
    return StepState.disabled;
  }

  PreferredSizeWidget _buildAppBar() {
    return BasicAppbar(
      hideBack: false,
      title: Text(
        'Create Group',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: AppSize.textHeading * 0.9.sp,
        ),
      ),
    );
  }
}
