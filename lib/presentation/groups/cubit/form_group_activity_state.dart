import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:Tracio/domain/map/entities/route.dart';

@immutable
abstract class FormGroupActivityState {
  final String activityName;
  final String description;
  final String meetingAddress;
  final Position? meetingLocation;
  final DateTime startDateTime;
  final int routeId;
  final RouteEntity? routeEntity;
  final bool isSuccess;
  final bool isLoading;
  final bool isFailed;
  final String errorMessage;

  const FormGroupActivityState(
      {required this.activityName,
      required this.description,
      required this.meetingAddress,
      required this.meetingLocation,
      required this.startDateTime,
      required this.routeId,
      required this.routeEntity,
      this.isSuccess = false,
      this.isLoading = true,
      this.isFailed = false,
      this.errorMessage = ''});

  FormGroupActivityState copyWith(
      {String? activityName,
      String? description,
      String? meetingAddress,
      Position? meetingLocation,
      DateTime? startDateTime,
      int? routeId,
      RouteEntity? routeEntity,
      bool? isSuccess,
      bool? isLoading,
      bool? isFailed,
      String? errorMessage});
}

class FormGroupActivityUpdate extends FormGroupActivityState {
  const FormGroupActivityUpdate(
      {required super.activityName,
      required super.description,
      required super.meetingAddress,
      required super.meetingLocation,
      required super.startDateTime,
      required super.routeId,
      required super.routeEntity,
      super.isSuccess = false,
      super.isLoading = false,
      super.isFailed = false,
      super.errorMessage = ''});

  @override
  FormGroupActivityUpdate copyWith(
      {String? activityName,
      String? description,
      String? meetingAddress,
      Position? meetingLocation,
      DateTime? startDateTime,
      int? routeId,
      RouteEntity? routeEntity,
      bool? isSuccess,
      bool? isLoading,
      bool? isFailed,
      String? errorMessage}) {
    return FormGroupActivityUpdate(
      activityName: activityName ?? this.activityName,
      description: description ?? this.description,
      meetingAddress: meetingAddress ?? this.meetingAddress,
      meetingLocation: meetingLocation ?? this.meetingLocation,
      startDateTime: startDateTime ?? this.startDateTime,
      routeId: routeId ?? this.routeId,
      routeEntity: routeEntity ?? this.routeEntity,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoading: isLoading ?? this.isLoading,
      isFailed: isFailed ?? this.isFailed,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
