import 'package:intl/intl.dart';

String formatDate(String dateTime,
    {bool showTime = true, bool onlyTime = false}) {
  final dateFormatter = DateFormat("d MMMM yyyy", 'id_ID');
  final timeFormatter = DateFormat("HH:mm 'WIB'", 'id_ID');

  DateTime parsedDate = DateTime.parse(dateTime);

  if (onlyTime) {
    return timeFormatter.format(parsedDate);
  } else if (showTime) {
    return '${dateFormatter.format(parsedDate)} ${timeFormatter.format(parsedDate)}';
  } else {
    return dateFormatter.format(parsedDate);
  }
}
