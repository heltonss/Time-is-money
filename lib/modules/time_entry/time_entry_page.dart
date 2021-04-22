import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_is_money/modules/common/error_page.dart';
import 'package:time_is_money/modules/model/entries_per_day.dart';
import 'package:time_is_money/modules/model/entries_per_month.dart';
import 'package:time_is_money/modules/model/entries_per_year.dart';
import 'package:time_is_money/modules/model/user.dart';
import 'package:time_is_money/modules/time_entry/time_entry_body.dart';
import 'package:time_is_money/modules/utils/dialog_util.dart';
import 'package:time_is_money/modules/utils/time_util.dart';
import 'package:vibration/vibration.dart';

import 'finger_print_button.dart';

class TimeEntryPage extends StatefulWidget {
  @override
  _TimeEntryPageState createState() => _TimeEntryPageState();
}

class _TimeEntryPageState extends State<TimeEntryPage> {
  final List<DateTime> _entries = <DateTime>[];
  final List<int> _entriesInSeconds = <int>[];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference entriesPerYearCollRef;
  CollectionReference entriesPerMonthCollRef;
  CollectionReference entriesPerDayCollRef;
  User loggedUser;
  String dailyEntryId;

  @override
  Widget build(BuildContext context) {
    loggedUser = ModalRoute.of(context).settings.arguments as User;
    entriesPerYearCollRef = firestore.collection('entries_per_year');
    entriesPerMonthCollRef = firestore.collection('entries_per_month');
    entriesPerDayCollRef = firestore.collection('entries_per_day');

    return buildPage();
  }

  FutureBuilder<DocumentSnapshot> buildPage() {
    Future<DocumentSnapshot> _getEntriesForUser() async {
      if (dailyEntryId == null) {
        final DateTime now = DateTime.now();
        final String yearKey = TimeUtil.generateYearKey(loggedUser, now);
        final DocumentSnapshot snapshot =
            await entriesPerYearCollRef.doc(yearKey).get();
        final Map<String, dynamic> entriesPerYearJson = snapshot.data();
        DocumentReference entriesPerDayRef;
        if (entriesPerYearJson != null) {
          final EntriesPerYear entriesPerYear =
              EntriesPerYear.fromJson(entriesPerYearJson);
          final String monthId = entriesPerYear
              .entriesPerMonthIds[now.month.toString()]
              .toString();
          if (monthId == null) {
            entriesPerDayRef =
                await createDayAndMonthEntry(now, entriesPerYear, yearKey);
          } else {
            final DocumentSnapshot entriesPerMonthSnapshot =
                await entriesPerMonthCollRef.doc(monthId).get();
            final Map<String, dynamic> entriesPerMonthData =
                entriesPerMonthSnapshot.data();
            if (entriesPerMonthData == null) {
              entriesPerDayRef =
                  await createDayAndMonthEntry(now, entriesPerYear, yearKey);
            } else {
              final EntriesPerMonth entriesPerMonth =
                  EntriesPerMonth.fromJson(entriesPerMonthData);
              final String dayId = entriesPerMonth
                  .entriesPerDayIds[now.day.toString()]
                  .toString();
              if (dayId == null || dayId == 'null') {
                entriesPerDayRef = await createEntriesPerDayDoc(now);
                entriesPerMonth.entriesPerDayIds[now.day.toString()] =
                    entriesPerDayRef.id;
                await entriesPerMonthCollRef
                    .doc(entriesPerMonthSnapshot.id)
                    .update(entriesPerMonth.toJson());
              } else {
                dailyEntryId = dayId;
              }
            }
          }
        } else {
          entriesPerDayRef = await createEntriesPerDayDoc(now);
          final DocumentReference entriesPerMonthRef =
              await createEntriesPerMonthDoc(now, entriesPerDayRef);
          await createEntriesPerYearDoc(yearKey, now, entriesPerMonthRef);
        }
        if (entriesPerDayRef != null) {
          dailyEntryId = entriesPerDayRef.id;
        }
      }
      return entriesPerDayCollRef.doc(dailyEntryId).get();
    }

    return FutureBuilder<DocumentSnapshot>(
        future: _getEntriesForUser(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return ErrorPage();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final Map<String, dynamic> data = snapshot.data.data();
            _entriesInSeconds.clear();
            final List entries = data['entries'] as List;
            if (entries != null) {
              _entriesInSeconds.addAll(List.from(entries));
              _entries.clear();
              for (final int entry in _entriesInSeconds) {
                _entries.add(DateTime.fromMicrosecondsSinceEpoch(entry));
              }
            }
            return buildScaffold(
                context: context, user: loggedUser, isLoading: false);
          }
          return buildScaffold(
              context: context, user: loggedUser, isLoading: true);
        });
  }

  Future<DocumentReference> createDayAndMonthEntry(
      DateTime now, EntriesPerYear entriesPerYear, String yearKey) async {
    final DocumentReference entriesPerDayRef =
        await createEntriesPerDayDoc(now);
    final DocumentReference entriesPerMonthRef =
        await createEntriesPerMonthDoc(now, entriesPerDayRef);
    entriesPerYear.entriesPerMonthIds[now.month.toString()] =
        entriesPerMonthRef.id;
    await entriesPerYearCollRef.doc(yearKey).update(entriesPerYear.toJson());
    return entriesPerDayRef;
  }

  Future<void> createEntriesPerYearDoc(String yearKey, DateTime now,
      DocumentReference entriesPerMonthRef) async {
    await entriesPerYearCollRef.doc(yearKey).set(EntriesPerYear(
            id: yearKey,
            year: now.year.toString(),
            entriesPerMonthIds: <String, String>{
              now.month.toString(): entriesPerMonthRef.id
            }).toJson());
  }

  Future<DocumentReference> createEntriesPerMonthDoc(
      DateTime now, DocumentReference entriesPerDayRef) async {
    final DocumentReference entriesPerMonthRef =
        await entriesPerMonthCollRef.add(EntriesPerMonth(
            month: now.month.toString(),
            entriesPerDayIds: <String, String>{
          now.day.toString(): entriesPerDayRef.id
        }).toJson());
    return entriesPerMonthRef;
  }

  Future<DocumentReference> createEntriesPerDayDoc(DateTime now) async {
    final DocumentReference entriesPerDayRef = await entriesPerDayCollRef
        .add(EntriesPerDay(day: now.day.toString()).toJson());
    return entriesPerDayRef;
  }

  Widget buildScaffold({BuildContext context, User user, bool isLoading}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time is Money'),
      ),
      body: TimeEntryBody(entries: _entries, isLoading: isLoading),
      floatingActionButton: FingerPrintButton(
        backgroundColor: _entries.length % 2 == 0 ? Colors.green : Colors.red,
        onPressed: () async {
          await _vibrate();
          final DateTime now = DateTime.now();
          _entriesInSeconds.add(now.microsecondsSinceEpoch);
          try {
            final EntriesPerDay entriesPerDay = EntriesPerDay(
                day: now.day.toString(), entries: _entriesInSeconds);
            await entriesPerDayCollRef
                .doc(dailyEntryId)
                .update(entriesPerDay.toJson());
          } catch (e) {
            DialogUtil.showErrorMessage(
                context, 'Erro ao registrar apontamento: ${e.toString()}');
            return;
          }
          setState(() {
            _entries.add(now);
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator()) {
      if (await Vibration.hasCustomVibrationsSupport()) {
        if (await Vibration.hasAmplitudeControl()) {
          Vibration.vibrate(duration: 100, amplitude: 80);
        } else {
          Vibration.vibrate(duration: 100);
        }
      } else {
        Vibration.vibrate();
      }
    }
  }
}
