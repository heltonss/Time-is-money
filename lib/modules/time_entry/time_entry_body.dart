import 'package:flutter/material.dart';
import 'package:time_is_money/modules/model/time_entry.dart';
import 'package:time_is_money/modules/time_entry/time_entry_info.dart';
import 'package:time_is_money/modules/time_entry/time_entry_list.dart';

class TimeEntryBody extends StatelessWidget {
  const TimeEntryBody({
    Key key,
    this.entries,
  }) : super(key: key);

  final List<TimeEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TimeEntryInfo(entries: entries),
        Expanded(child: TimeEntryList(entries: entries)),
      ],
    );
  }
}
