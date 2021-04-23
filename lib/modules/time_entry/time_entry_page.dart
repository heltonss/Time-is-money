import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_is_money/modules/common/error_page.dart';
import 'package:time_is_money/modules/model/user.dart';
import 'package:time_is_money/modules/time_entry/time_entry_body.dart';
import 'package:time_is_money/modules/time_entry/time_entry_dao.dart';
import 'package:time_is_money/modules/utils/dialog_util.dart';
import 'package:vibration/vibration.dart';

import 'finger_print_button.dart';

class TimeEntryPage extends StatefulWidget {
  @override
  _TimeEntryPageState createState() => _TimeEntryPageState();
}

class _TimeEntryPageState extends State<TimeEntryPage> {
  List<DateTime> _entries;
  List<int> _entriesInSeconds;

  String dailyEntryId;

  TimeEntryDAO timeEntryDAO;

  @override
  Widget build(BuildContext context) {
    final User loggedUser = ModalRoute.of(context).settings.arguments as User;

    final DateTime currentDate = DateTime.now();

    timeEntryDAO = TimeEntryDAO(
        firestore: FirebaseFirestore.instance,
        currentDate: currentDate,
        yearKey: '${loggedUser.email}_${currentDate.year}');

    return buildPage();
  }

  FutureBuilder<DocumentSnapshot> buildPage() {
    return FutureBuilder<DocumentSnapshot>(
        future: getEntriesForUser(),
        builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snap) {
          if (snap.hasError) return ErrorPage();
          if (snap.connectionState == ConnectionState.done) {
            populateList(snap);
          }
          return buildTimeEntryPage(context: ctx);
        });
  }

  Widget buildTimeEntryPage({BuildContext context}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time is Money'),
      ),
      body: TimeEntryBody(
        entries: _entries ?? <DateTime>[],
        isLoading: _entries == null,
      ),
      floatingActionButton: FingerPrintButton(
        backgroundColor: getFloatingButtonColor(),
        onPressed: () async {
          await _vibrate();
          await registerEntry(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  MaterialColor getFloatingButtonColor() {
    return _entries == null || _entries.length % 2 == 0
        ? Colors.green
        : Colors.red;
  }

  Future<void> registerEntry(BuildContext context) async {
    final DateTime now = DateTime.now();
    _entriesInSeconds.add(now.microsecondsSinceEpoch);
    try {
      await timeEntryDAO.registerEntry(
          dailyEntryId, now.day.toString(), _entriesInSeconds);
    } catch (e) {
      DialogUtil.showErrorMessage(
          context, 'Erro ao registrar apontamento: ${e.toString()}');
      return;
    }
    setState(() {
      _entries.add(now);
    });
  }

  void populateList(AsyncSnapshot<DocumentSnapshot> snapshot) {
    final Map<String, dynamic> data = snapshot.data.data();
    final dynamic entries = data['entries'];
    if (entries != null) {
      _entries = <DateTime>[];
      // ignore: always_specify_types
      _entriesInSeconds = List<int>.from(entries as List);
      for (final int entry in _entriesInSeconds) {
        _entries.add(DateTime.fromMicrosecondsSinceEpoch(entry));
      }
    }
  }

  Future<DocumentSnapshot> getEntriesForUser() async {
    dailyEntryId ??= await timeEntryDAO.getOrCreateDailyEntryId();
    return timeEntryDAO.getEntries(dailyEntryId);
  }

  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator()) {
      if (await Vibration.hasCustomVibrationsSupport()) {
        if (await Vibration.hasAmplitudeControl()) {
          Vibration.vibrate(duration: 100, amplitude: 100);
        } else {
          Vibration.vibrate(duration: 100);
        }
      } else {
        Vibration.vibrate();
      }
    }
  }
}
