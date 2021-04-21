import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_is_money/modules/model/time_entry.dart';
import 'package:time_is_money/modules/utils/time_util.dart';

import 'info_item.dart';

class TimeEntryInfo extends StatefulWidget {
  const TimeEntryInfo({
    Key key,
    this.entries,
  }) : super(key: key);

  final List<TimeEntry> entries;

  static const String dateLabel = 'Data:';
  static const String currentTimeLabel = 'Hora Atual:';
  static const String workedTimeLabel = 'Tempo trabalhado:';

  @override
  _TimeEntryInfoState createState() => _TimeEntryInfoState();
}

class _TimeEntryInfoState extends State<TimeEntryInfo> {
  final Duration _timeout = const Duration(seconds: 1);
  String currentTime;

  @override
  void initState() {
    currentTime = DateFormat.Hms().format(DateTime.now());
    _startTimeout();
    super.initState();
  }

  void _startTimeout() {
    Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    _startTimeout();
    setState(() {
      currentTime = DateFormat.Hms().format(DateTime.now());
    });
  }

  String calculateWorkingTime() {
    final Duration totalDuration = TimeUtil.calculateDuration(widget.entries);

    return TimeUtil.durationToHms(totalDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InfoItem(label: TimeEntryInfo.dateLabel, value: TimeUtil.formatDate(DateTime.now())),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InfoItem(label: TimeEntryInfo.currentTimeLabel, value: currentTime),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InfoItem(
            label: TimeEntryInfo.workedTimeLabel, value: calculateWorkingTime()),
      ),
      const SizedBox(
        height: 2,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.blue),
        ),
      ),

    ]);
  }
}
