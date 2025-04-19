import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension DateTimeExtension on DateTime {
  DateTime get onlyDate => DateTime(year, month, day);

  String formatToDayTimeWithTimezone() {
    // Create DateFormat with desired pattern
    final dateFormat =
        DateFormat('EEEE h:mm a'); // EEEE gives day, h:mm a gives time in AM/PM
    final formattedDate = dateFormat.format(toLocal());

    // Format timezone offset
    final timezoneOffset = timeZoneOffset;
    final hoursOffset = timezoneOffset.inHours.abs().toString().padLeft(2, '0');
    final minutesOffset =
        (timezoneOffset.inMinutes % 60).abs().toString().padLeft(2, '0');
    final sign = timezoneOffset.isNegative ? '-' : '+';

    return "$formattedDate GMT$sign$hoursOffset:$minutesOffset";
  }

  String formatTimeAgo() => timeago.format(this);

}

String formatTime(int o) {
  // Calculate the days, hours, minutes, and seconds
  int days = (o / 86400).floor(); // 86400 seconds in a day
  int hours = (o / 3600).floor() - 24 * days; // 3600 seconds in an hour
  int minutes =
      (o / 60).floor() - 60 * hours - 24 * days * 60; // 60 seconds in a minute
  int seconds = o - 60 * minutes - 60 * hours * 60 - 24 * days * 60 * 60;

  // Build the formatted string
  return '${days > 0 ? '$days d ' : ''}$hours h $minutes m $seconds s';
}
