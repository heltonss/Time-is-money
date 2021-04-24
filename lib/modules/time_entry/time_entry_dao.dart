import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_is_money/modules/model/entries_per_day.dart';
import 'package:time_is_money/modules/model/entries_per_month.dart';
import 'package:time_is_money/modules/model/entries_per_year.dart';

class TimeEntryDAO {
  TimeEntryDAO({this.firestore, this.currentDate, this.yearKey}) {
    dayCollRef = firestore.collection('entries_per_day');
    monthCollRef = firestore.collection('entries_per_month');
    yearCollRef = firestore.collection('entries_per_year');
  }

  final DateTime currentDate;
  final String yearKey;
  final FirebaseFirestore firestore;

  CollectionReference dayCollRef;
  CollectionReference monthCollRef;
  CollectionReference yearCollRef;

  Future<DocumentReference> createEntriesPerDayDoc() async {
    final String day = currentDate.day.toString();
    final EntriesPerDay entries = EntriesPerDay(day: day, entries: <int>[]);
    return dayCollRef.add(entries.toJson());
  }

  Future<DocumentReference> createEntriesPerMonthDoc(
      DocumentReference entriesPerDayRef) async {
    final String month = currentDate.month.toString();
    final Map<String, dynamic> ids = <String, dynamic>{
      currentDate.day.toString(): entriesPerDayRef.id
    };
    final EntriesPerMonth entries =
        EntriesPerMonth(month: month, entriesPerDayIds: ids);
    return monthCollRef.add(entries.toJson());
  }

  Future<void> createEntriesPerYearDoc(
      String yearKey, DocumentReference entriesPerMonthRef) async {
    final String year = currentDate.year.toString();
    final Map<String, dynamic> ids = <String, dynamic>{
      currentDate.month.toString(): entriesPerMonthRef.id
    };
    final EntriesPerYear entries =
        EntriesPerYear(id: yearKey, year: year, entriesPerMonthIds: ids);
    await yearCollRef.doc(yearKey).set(entries.toJson());
  }

  Future<DocumentReference> createDayAndMonthEntry(
      EntriesPerYear entriesPerYear) async {
    final DocumentReference entriesPerDayRef = await createEntriesPerDayDoc();
    final DocumentReference entriesPerMonthRef =
        await createEntriesPerMonthDoc(entriesPerDayRef);
    entriesPerYear.entriesPerMonthIds[currentDate.month.toString()] =
        entriesPerMonthRef.id;
    await yearCollRef.doc(yearKey).update(entriesPerYear.toJson());
    return entriesPerDayRef;
  }

  Future<Map<String, dynamic>> getEntriesPerYear() async {
    final DocumentSnapshot yearSnap = await yearCollRef.doc(yearKey).get();
    final Map<String, dynamic> yearJson = yearSnap.data();
    return yearJson;
  }

  Future<String> getOrCreateDailyEntryId() async {
    DocumentReference entriesPerDayRef;
    final Map<String, dynamic> yearJson = await getEntriesPerYear();
    if (yearJson != null) {
      final EntriesPerYear entriesPerYear = EntriesPerYear.fromJson(yearJson);
      final String monthId = entriesPerYear
          .entriesPerMonthIds[currentDate.month.toString()]
          .toString();
      if (monthId == null) {
        entriesPerDayRef = await createDayAndMonthEntry(entriesPerYear);
      } else {
        final DocumentSnapshot entriesPerMonthSnapshot =
            await monthCollRef.doc(monthId).get();
        final Map<String, dynamic> monthJson = entriesPerMonthSnapshot.data();
        if (monthJson == null) {
          entriesPerDayRef = await createDayAndMonthEntry(entriesPerYear);
        } else {
          final EntriesPerMonth entriesPerMonth =
              EntriesPerMonth.fromJson(monthJson);
          String dayId = entriesPerMonth
              .entriesPerDayIds[currentDate.day.toString()]
              .toString();
          if (dayId != null) {
            final DocumentSnapshot daySnap = await dayCollRef.doc(dayId).get();
            final Map<String, dynamic> dayJson = daySnap.data();
            if (dayJson == null) {
              dayId = null;
            }
          }
          if (dayId == null || dayId == 'null') {
            entriesPerDayRef = await createEntriesPerDayDoc();
            entriesPerMonth.entriesPerDayIds[currentDate.day.toString()] =
                entriesPerDayRef.id;
            await monthCollRef
                .doc(entriesPerMonthSnapshot.id)
                .update(entriesPerMonth.toJson());
          } else {
            return dayId;
          }
        }
      }
    } else {
      entriesPerDayRef = await createEntriesPerDayDoc();
      final DocumentReference entriesPerMonthRef =
          await createEntriesPerMonthDoc(entriesPerDayRef);
      await createEntriesPerYearDoc(yearKey, entriesPerMonthRef);
    }
    return entriesPerDayRef.id;
  }

  Future<DocumentSnapshot> getEntries(String dailyEntryId) async {
    return dayCollRef.doc(dailyEntryId).get();
  }

  Future<void> registerEntry(
      String dailyEntryId, String day, List<int> entriesInSeconds) async {
    await dayCollRef
        .doc(dailyEntryId)
        .update(EntriesPerDay(day: day, entries: entriesInSeconds).toJson());
  }
}
