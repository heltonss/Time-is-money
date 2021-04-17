import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_is_money/modules/model/time_entry.dart';
import 'package:time_is_money/modules/utils/time_util.dart';

import 'info_item.dart';

class TimeEntryInfo extends StatelessWidget {
  const TimeEntryInfo({
    Key key,
    this.entries,
  }) : super(key: key);

  final List<TimeEntry> entries;

  String calculateWorkingTime() {
    final Duration totalDuration = TimeUtil.calculateDuration(entries);

    return TimeUtil.durationToHms(totalDuration);
  }

  static const String currentTimeLabel = 'Hora Atual:';
  static const String workedTimeLabel = 'Tempo trabalhado:';

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const SizedBox(height: 10),
      InfoItem(
          label: currentTimeLabel,
          value: DateFormat.Hms().format(DateTime.now())),
      const SizedBox(height: 10),
      InfoItem(label: workedTimeLabel, value: calculateWorkingTime()),
      const SizedBox(height: 10),
      const SizedBox(
        height: 2,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.blue),
        ),
      ),
      const SizedBox(height: 10),
    ]);
  }
}
