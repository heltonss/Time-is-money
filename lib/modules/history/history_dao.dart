import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_is_money/modules/history/entities/history_entry.dart';
import 'package:time_is_money/modules/history/history_constants.dart';
import 'package:time_is_money/modules/model/entries_per_day.dart';
import 'package:time_is_money/modules/model/entries_per_month.dart';
import 'package:time_is_money/modules/model/entries_per_year.dart';
import 'package:time_is_money/modules/utils/time_util.dart';

class HistoryDAO {
  HistoryDAO({this.firestore}) {
    dayCollRef = firestore.collection('entries_per_day');
    monthCollRef = firestore.collection('entries_per_month');
    yearCollRef = firestore.collection('entries_per_year');
  }

  final FirebaseFirestore firestore;

  CollectionReference dayCollRef;
  CollectionReference monthCollRef;
  CollectionReference yearCollRef;

  Future<HistoryEntry> getTimePerYear(String yearKey) async {
    final DocumentSnapshot yearSnap = await yearCollRef.doc(yearKey).get();
    final EntriesPerYear yearEntries = EntriesPerYear.fromJson(yearSnap.data());

    final List<HistoryEntry> monthEntries = <HistoryEntry>[];
    for (final dynamic monthKey in yearEntries.entriesPerMonthIds.values) {
      await getTimePerMonth(monthKey as String).then((HistoryEntry value) {
        monthEntries.add(value);
      });
    }

    final int totalTime = monthEntries.fold(
        0, (int total, HistoryEntry element) => total += element.totalTime);

    return HistoryEntry(
        period: HistoryConstants.perYear,
        totalTime: totalTime,
        title: yearEntries.year,
        subEntries: monthEntries,
        entryRecord: <DateTime>[]);
  }

  Future<HistoryEntry> getTimePerMonth(String monthKey) async {
    final DocumentSnapshot monthSnap = await monthCollRef.doc(monthKey).get();
    final EntriesPerMonth monthEntry =
        EntriesPerMonth.fromJson(monthSnap.data());

    final List<HistoryEntry> dayEntries = <HistoryEntry>[];
    for (final dynamic dayKey in monthEntry.entriesPerDayIds.values) {
      await getTimePerDay(dayKey as String).then((HistoryEntry value) {
        dayEntries.add(value);
      });
    }

    final int totalTime = dayEntries.fold(
        0, (int total, HistoryEntry element) => total += element.totalTime);

    return HistoryEntry(
        period: HistoryConstants.perMonth,
        totalTime: totalTime,
        title:
            TimeUtil.convertMonthNumberToMonthName(int.parse(monthEntry.month)),
        subEntries: dayEntries,
        entryRecord: <DateTime>[]);
  }

  Future<HistoryEntry> getTimePerDay(String dayKey) async {
    final DocumentSnapshot daySnap = await dayCollRef.doc(dayKey).get();
    final EntriesPerDay dailyEntry = EntriesPerDay.fromJson(daySnap.data());

    final List<DateTime> dateTimeEntries = dailyEntry.entries.map((int entry) {
      return DateTime.fromMicrosecondsSinceEpoch(entry);
    }).toList();
    final Duration duration = TimeUtil.calculateDuration(dateTimeEntries);
    final int totalTime = duration.inSeconds;

    return HistoryEntry(
        period: HistoryConstants.perDay,
        totalTime: totalTime,
        title: dailyEntry.day,
        subEntries: <HistoryEntry>[],
        entryRecord: dateTimeEntries);
  }
}
