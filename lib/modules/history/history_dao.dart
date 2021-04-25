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
    EntriesPerYear yearEntries = EntriesPerYear.fromJson(yearSnap.data());

    yearEntries.entriesPerMonthIds.forEach((key, value) {});

    return HistoryYear(totalTime: 0, year: "");
  }

  Future<HistoryMonth> getTimePerMonth(String monthKey) async {
    final DocumentSnapshot monthSnap = await monthCollRef.doc(monthKey).get();
    EntriesPerMonth monthEntries = EntriesPerMonth.fromJson(monthSnap.data());

    return HistoryMonth(totalTime: 0, month: "");
  }

  Future<HistoryDay> getTimePerDay(String dayKey) async {
    final DocumentSnapshot daySnap = await dayCollRef.doc(dayKey).get();
    EntriesPerDay dayEntries = EntriesPerDay.fromJson(daySnap.data());

    int totalTime =
        dayEntries.entries.reduce((int total, int seconds) => total += seconds);

    return HistoryDay(
        totalTime: totalTime,
        day: dayEntries.day,
        apointments: dayEntries.entries);
  }
}
