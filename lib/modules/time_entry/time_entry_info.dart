import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_is_money/modules/utils/time_util.dart';

import 'info_item.dart';

class TimeEntryInfo extends StatefulWidget {
  const TimeEntryInfo({
    Key key,
    this.entries,
    this.isLoading,
  }) : super(key: key);

  final List<DateTime> entries;
  final bool isLoading;

  static const String dateLabel = 'Data:';
  static const String currentTimeLabel = 'Hora Atual:';
  static const String workedTimeLabel = 'Tempo trabalhado:';
  static const String loadingLabel = 'Carregando...';

  @override
  _TimeEntryInfoState createState() => _TimeEntryInfoState();
}

class _TimeEntryInfoState extends State<TimeEntryInfo> {
  final Duration _timeout = const Duration(seconds: 1);
  String currentTime;

  Timer timer;

  @override
  void initState() {
    currentTime = DateFormat.Hms().format(DateTime.now());
    _startTimeout();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startTimeout() {
    timer?.cancel();
    timer = Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    _startTimeout();
    setState(() {
      currentTime = DateFormat.Hms().format(DateTime.now());
    });
  }

  String calculateWorkingTime() {
    if (widget.isLoading) return TimeEntryInfo.loadingLabel;

    final Duration totalDuration = TimeUtil.calculateDuration(widget.entries);

    return TimeUtil.durationToHms(totalDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InfoItem(
            label: TimeEntryInfo.dateLabel,
            value: TimeUtil.formatDate(DateTime.now())),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            InfoItem(label: TimeEntryInfo.currentTimeLabel, value: currentTime),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InfoItem(
            label: TimeEntryInfo.workedTimeLabel,
            value: calculateWorkingTime()),
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
