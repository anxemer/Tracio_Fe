import 'package:logger/logger.dart';

final Logger signalrLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    colors: true,
    dateTimeFormat: DateTimeFormat.dateAndTime,
    lineLength: 100,
  ),
);