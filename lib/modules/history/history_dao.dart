import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_is_money/modules/history/entities/history_day.dart';
import 'package:time_is_money/modules/history/entities/history_month.dart';
import 'package:time_is_money/modules/history/entities/history_year.dart';
import 'package:time_is_money/modules/model/entries_per_day.dart';
import 'package:time_is_money/modules/model/entries_per_month.dart';
import 'package:time_is_money/modules/model/entries_per_year.dart';

class HistoryDAO {
  HistoryDAO({this.firestore, this.period}) {
    dayCollRef = firestore.collection('entries_per_day');
    monthCollRef = firestore.collection('entries_per_month');
    yearCollRef = firestore.collection('entries_per_year');
  }

  final FirebaseFirestore firestore;
  final String period;

  CollectionReference dayCollRef;
  CollectionReference monthCollRef;
  CollectionReference yearCollRef;

  Future<HistoryYear> getTimePerYear(String yearKey) async {
    final DocumentSnapshot yearSnap = await yearCollRef.doc(yearKey).get();
    final EntriesPerYear yearEntries = EntriesPerYear.fromJson(yearSnap.data());

    yearEntries.entriesPerMonthIds.forEach((key, value) {});

    List<HistoryMonth> monthEntries;
    for (final dynamic monthKey in yearEntries.entriesPerMonthIds.values) {
      getTimePerMonth(monthKey as String).then((HistoryMonth value) {
        monthEntries.add(value);
      });
    }

    final int totalTime = monthEntries.fold(
        0, (int total, HistoryMonth element) => total += element.totalTime);

    return HistoryYear(
        totalTime: totalTime,
        year: yearEntries.year,
        monthEntries: monthEntries);
  }

  Future<HistoryMonth> getTimePerMonth(String monthKey) async {
    final DocumentSnapshot monthSnap = await monthCollRef.doc(monthKey).get();
    final EntriesPerMonth monthEntries =
        EntriesPerMonth.fromJson(monthSnap.data());

    List<HistoryDay> dayEntries;
    for (final dynamic dayKey in monthEntries.entriesPerDayIds.values) {
      getTimePerDay(dayKey as String).then((HistoryDay value) {
        dayEntries.add(value);
      });
    }

    final int totalTime = dayEntries.fold(
        0, (int total, HistoryDay element) => total += element.totalTime);

    return HistoryMonth(
        dayEntries: dayEntries,
        month: monthEntries.month,
        totalTime: totalTime);
  }

  Future<HistoryDay> getTimePerDay(String dayKey) async {
    final DocumentSnapshot daySnap = await dayCollRef.doc(dayKey).get();
    final EntriesPerDay dayEntries = EntriesPerDay.fromJson(daySnap.data());

    final int totalTime =
        dayEntries.entries.reduce((int total, int seconds) => total += seconds);

    return HistoryDay(
        totalTime: totalTime,
        day: dayEntries.day,
        apointments: dayEntries.entries);
  }
}
