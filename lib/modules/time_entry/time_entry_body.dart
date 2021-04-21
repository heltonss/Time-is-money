import 'package:flutter/material.dart';
import 'package:time_is_money/modules/model/time_entry.dart';
import 'package:time_is_money/modules/time_entry/time_entry_info.dart';
import 'package:time_is_money/modules/time_entry/time_entry_list.dart';

class TimeEntryBody extends StatelessWidget {
  const TimeEntryBody({
    Key key,
    this.entries,
    this.isLoading,
  }) : super(key: key);

  final List<TimeEntry> entries;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TimeEntryInfo(entries: entries, isLoading: isLoading),
        buildList(),
      ],
    );
  }

  Widget buildList() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      );
    }
    return Expanded(child: TimeEntryList(entries: entries));
  }
}
