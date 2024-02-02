import 'package:intl/intl.dart';

String dateFromatter({String? dateTimeAsString, required String dateFormat}) {
  String format =
      DateFormat(dateFormat).format(DateTime.parse(dateTimeAsString ?? ""));
  return format;
}
