import 'package:flutter/material.dart';
import 'package:time_is_money/modules/model/time_entry.dart';
import 'package:time_is_money/modules/time_entry/time_entry_body.dart';

import 'finger_print_button.dart';

class TimeEntryPage extends StatefulWidget {
  @override
  _TimeEntryPageState createState() => _TimeEntryPageState();
}

class _TimeEntryPageState extends State<TimeEntryPage> {
  final List<TimeEntry> _entries = <TimeEntry>[];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time is Money',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Time is Money'),
        ),
        body: TimeEntryBody(entries: _entries),
        floatingActionButton: FingerPrintButton(
          backgroundColor: _entries.length % 2 == 0 ? Colors.green : Colors.red,
          onPressed: () {
            setState(() {
              _entries.add(TimeEntry(DateTime.now()));
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
