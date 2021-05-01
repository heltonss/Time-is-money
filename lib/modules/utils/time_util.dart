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
            (entry.difference(periodEntrance).inMilliseconds / 1000).round();
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

  static String parseMonthKeyFromDate(DateTime date) {
    return '${date.year}-${twoDigits(date.month)}';
  }

  static String parseDayKeyFromDate(DateTime date) {
    return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
  }

  static String formatDate(DateTime date) {
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year}';
  }

  static String convertMonthNumberToMonthName(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'Janeiro';
        break;
      case 2:
        return 'Fevereiro';
        break;
      case 3:
        return 'Março';
        break;
      case 4:
        return 'Abril';
        break;
      case 5:
        return 'Maio';
        break;
      case 6:
        return 'Junho';
        break;
      case 7:
        return 'Julho';
        break;
      case 8:
        return 'Agosto';
        break;
      case 9:
        return 'Setembro';
        break;
      case 10:
        return 'Outubro';
        break;
      case 11:
        return 'Novembro';
        break;
      case 12:
        return 'Dezembro';
        break;
      default:
        return '';
    }
  }
}
