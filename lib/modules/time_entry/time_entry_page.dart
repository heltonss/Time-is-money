import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_is_money/modules/common/error_page.dart';
import 'package:time_is_money/modules/model/time_entry.dart';
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
  final List<TimeEntry> _entries = <TimeEntry>[];
  final List<int> _entriesInSeconds = <int>[];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final User user = User(
      userName: 'Helton',
      email: 'helton.isac@gmail.com',
      userId: 'PQeK98vj6XFJjGP88CPR');
  final String dailyEntryId = 'XgdiYU9myVqluCSJRDvP';

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments as User;

    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('user');

    final CollectionReference dailyEntry =
        FirebaseFirestore.instance.collection('daily_entry');

    return FutureBuilder<DocumentSnapshot>(
        future: dailyEntry.doc(dailyEntryId).get(),
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
                _entries
                    .add(TimeEntry(DateTime.fromMicrosecondsSinceEpoch(entry)));
              }
            }
            return buildScaffold(context, user, false);
          }
          return buildScaffold(context, user, true);
        });
  }

  Widget buildScaffold(BuildContext context, User user, bool isLoading) {
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
            await firestore
                .collection('daily_entry')
                .doc('XgdiYU9myVqluCSJRDvP')
                .update({
              'day': TimeUtil.parseDayKeyFromDate(now),
              'user_id': user.userId,
              'entries': _entriesInSeconds
            });
          } catch (e) {
            DialogUtil.showErrorMessage(
                context, 'Erro ao registrar apontamento: ${e.toString()}');
            return;
          }
          setState(() {
            _entries.add(TimeEntry(now));
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
