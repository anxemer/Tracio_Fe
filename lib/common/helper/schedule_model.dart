import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ScheduleModel {
  final DateTime? date;
  final TimeOfDay? timeFrom;
  final TimeOfDay? timeTo;

  ScheduleModel({
    required this.date,
    required this.timeFrom,
    required this.timeTo,
  });

  @override
  String toString() {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    return '${dateFormat.format(date!)}: ${timeFrom!.format(navigatorKey.currentContext!)} - ${timeTo!.format(navigatorKey.currentContext!)}';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateFree': date?.toIso8601String(),
      'timeFrom': _timeOfDayToString(timeFrom),
      'timeTo': _timeOfDayToString(timeTo),
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      date: map['dateFree'] != null ? DateTime.parse(map['dateFree']) : null,
      timeFrom:
          map['timeFrom'] != null ? _stringToTimeOfDay(map['timeFrom']) : null,
      timeTo: map['timeTo'] != null ? _stringToTimeOfDay(map['timeTo']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleModel.fromJson(String source) =>
      ScheduleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // Helper functions
  static String _timeOfDayToString(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00'; // format like "09:00:00"
  }

  static TimeOfDay _stringToTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  DateTime? get timeFromAsDateTime {
    if (date != null && timeFrom != null) {
      return DateTime(
          date!.year, date!.month, date!.day, timeFrom!.hour, timeFrom!.minute);
    }
    return null;
  }

  DateTime? get timeToAsDateTime {
    if (date != null && timeTo != null) {
      return DateTime(
          date!.year, date!.month, date!.day, timeTo!.hour, timeTo!.minute);
    }
    return null;
  }
}
