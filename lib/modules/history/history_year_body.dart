import 'package:flutter/material.dart';
import 'package:time_is_money/modules/history/history_entry_list.dart';

import 'entities/history_entry.dart';

class HistoryYearBody extends StatelessWidget {
  const HistoryYearBody({
    Key key,
    this.yearData,
    this.isLoading,
  }) : super(key: key);

  final HistoryEntry yearData;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // TimeEntryInfo(entries: entries, isLoading: isLoading),
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
    return Expanded(child: HistoryEntryList(entries: yearData.subEntries));
  }
}
