import 'package:time_is_money/modules/history/entities/history_month.dart';

class HistoryYear {
  HistoryYear({this.year, this.totalTime, this.monthEntries});

  final String year;
  final int totalTime;
  final List<HistoryMonth> monthEntries;
}
