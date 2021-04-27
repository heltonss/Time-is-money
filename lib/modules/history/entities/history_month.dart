import 'history_day.dart';

class HistoryMonth {
  HistoryMonth({this.month, this.totalTime, this.dayEntries});

  final String month;
  final int totalTime;
  final List<HistoryDay> dayEntries;
}
