import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeEntryList extends StatelessWidget {
  const TimeEntryList({
    Key key,
    this.entries,
  }) : super(key: key);

  final List<DateTime> entries;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: buildListItems(entries),
    );
  }
}

List<Widget> buildListItems(List<DateTime> entries) {
  final List<Widget> listItems = <Widget>[];
  bool isPeriodEntrance = true;
  for (final DateTime entry in entries) {
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
      title: Text(DateFormat.Hms().format(entry)),
    ));
    isPeriodEntrance = !isPeriodEntrance;
  }

  return listItems;
}
