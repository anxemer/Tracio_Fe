import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleModel {
  final DateTime date;
  final TimeOfDay timeFrom;
  final TimeOfDay timeTo;

  ScheduleModel({
    required this.date,
    required this.timeFrom,
    required this.timeTo,
  });

  @override
  String toString() {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    return '${dateFormat.format(date)}: ${timeFrom.format(navigatorKey.currentContext!)} - ${timeTo.format(navigatorKey.currentContext!)}';
  }
}
// GlobalKey cho navigatorKey
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();