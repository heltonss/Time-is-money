import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_is_money/modules/model/time_entry.dart';

class TimeEntryList extends StatelessWidget {
  const TimeEntryList({
    Key key,
    this.entries,
  }) : super(key: key);

  final List<TimeEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: buildListItems(entries),
    );
  }
}

List<Widget> buildListItems(List<TimeEntry> entries) {
  final List<Widget> listItems = [];
  bool isPeriodEntrance = true;
  for (final TimeEntry entry in entries) {
    listItems.add(ListTile(
      leading:
          Icon(isPeriodEntrance ? Icons.arrow_downward : Icons.arrow_upward),
      title: Text(DateFormat.Hm().format(entry.timeEntry)),
    ));
    isPeriodEntrance = !isPeriodEntrance;
  }

  return listItems;
}
