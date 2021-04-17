import 'package:flutter/material.dart';

import 'finger_print_button.dart';

class TimeEntryPage extends StatefulWidget {
  @override
  _TimeEntryPageState createState() => _TimeEntryPageState();
}

class _TimeEntryPageState extends State<TimeEntryPage> {
  List<String> _entries = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time is Money',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Time is Money'),
        ),
        body: const Center(
          child: Text('Tudo calmo por aqui!'),
        ),
        floatingActionButton: FingerPrintButton(
          backgroundColor: _entries.length % 2 == 0 ? Colors.green : Colors.red,
          onPressed: () {
            setState(() {
              final DateTime now = DateTime.now();
              _entries.add(now.toString());
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
