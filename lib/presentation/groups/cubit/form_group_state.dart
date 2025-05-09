part of 'form_group_cubit.dart';

@immutable
abstract class FormGroupState {
  final AutovalidateMode autovalidateMode;
  final GroupReq groupRequest;
  final bool canNext;
  final bool canSubmit;

  const FormGroupState(
      {required this.autovalidateMode,
      required this.groupRequest,
      this.canNext = false,
      this.canSubmit = false});

  FormGroupState copyWith(
      {AutovalidateMode? autovalidateMode,
      GroupReq? groupRequest,
      bool? canNext,
      bool? canSubmit});
}

class FormGroupStateUpdate extends FormGroupState {
  // ignore: use_super_parameters
  const FormGroupStateUpdate(
      {AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      required GroupReq groupRequest,
      bool canNext = false,
      bool canSubmit = false})
      : super(
            autovalidateMode: autovalidateMode,
            groupRequest: groupRequest,
            canNext: canNext,
            canSubmit: canSubmit);

  @override
  FormGroupStateUpdate copyWith(
      {AutovalidateMode? autovalidateMode,
      GroupReq? groupRequest,
      bool? canNext,
      bool? canSubmit}) {
    return FormGroupStateUpdate(
        autovalidateMode: autovalidateMode ?? this.autovalidateMode,
        groupRequest: groupRequest ?? this.groupRequest,
        canNext: canNext ?? this.canNext,
        canSubmit: canSubmit ?? this.canSubmit);
  }
}
