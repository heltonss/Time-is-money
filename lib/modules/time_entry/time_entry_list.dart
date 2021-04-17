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
    Icon icon;
    if (isPeriodEntrance) {
      icon = const Icon(
        Icons.arrow_downward,
        color: Colors.green,
      );
    } else {
      icon = const Icon(
        Icons.arrow_upward,
        color: Colors.red,
      );
    }

    listItems.add(ListTile(
      leading: icon,
      title: Text(DateFormat.Hms().format(entry.timeEntry)),
    ));
    isPeriodEntrance = !isPeriodEntrance;
  }

  return listItems;
}
