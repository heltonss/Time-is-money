import 'package:time_is_money/modules/model/time_entry.dart';
import 'package:time_is_money/modules/model/user.dart';

class TimeUtil {
  static const int secondsPerMinute = 60;
  static const int minutesPerHour = 60;

  static Duration calculateDuration(List<DateTime> entries) {
    DateTime periodEntrance;

    int totalWorkingTimeInSeconds = 0;

    for (final DateTime entry in entries) {
      if (periodEntrance == null) {
        periodEntrance = entry;
      } else {
        totalWorkingTimeInSeconds +=
            entry.difference(periodEntrance).inSeconds;
        periodEntrance = null;
      }
    }

    return Duration(seconds: totalWorkingTimeInSeconds);
  }

  static String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  static String durationToHms(Duration duration) {
    if (duration.inMicroseconds < 0) {
      return '-${-duration}';
    }
    final String twoDigitMinutes =
        twoDigits(duration.inMinutes.remainder(minutesPerHour) as int);
    final String twoDigitSeconds =
        twoDigits(duration.inSeconds.remainder(secondsPerMinute) as int);
    return '${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds';
  }

  static String generateYearKey(User user, DateTime date) {
    return '${user.email}_${date.year}';
  }

  static String parseMonthKeyFromDate(DateTime date) {
    return '${date.year}-${twoDigits(date.month)}';
  }

  static String parseDayKeyFromDate(DateTime date) {
    return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
  }

  static String formatDate(DateTime date) {
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year}';
  }
}
