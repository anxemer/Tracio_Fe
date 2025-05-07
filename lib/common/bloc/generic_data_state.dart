import 'package:Tracio/core/erorr/failure.dart';

abstract class GenericDataState {}

class DataLoading extends GenericDataState {}

class DataLoaded<T> extends GenericDataState {
  final T data;
  DataLoaded({required this.data});
}

class FailureLoadData extends GenericDataState {
  final String errorMessage;
  final Failure failure;
  FailureLoadData(this.failure, {required this.errorMessage});
}
