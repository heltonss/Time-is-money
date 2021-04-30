import 'package:flutter/material.dart';
import 'package:time_is_money/modules/history/history_constants.dart';
import 'package:time_is_money/modules/utils/time_util.dart';

import 'entities/history_entry.dart';

class HistoryEntryList extends StatelessWidget {
  const HistoryEntryList({
    Key key,
    this.entries,
  }) : super(key: key);

  final List<HistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: buildListItems(entries),
    );
  }
}

List<Widget> buildListItems(List<HistoryEntry> entries) {
  final List<Widget> listItems = <Widget>[];
  for (final HistoryEntry entry in entries) {
    switch (entry.period) {
      case HistoryConstants.perYear:
      case HistoryConstants.perMonth:
        listItems.add(Card(
          child: Column(
            children: <Widget>[
              Text(entry.title, style: const TextStyle(color: Colors.black)),
              Text(TimeUtil.durationToHms(Duration(seconds: entry.totalTime)))
            ],
          ),
        ));
        break;
      default:
        break;
    }

    return listItems;
  }
}
