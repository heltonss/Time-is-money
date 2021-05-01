import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_is_money/modules/history/entities/history_entry.dart';
import 'package:time_is_money/modules/utils/time_util.dart';

class HistoryMonthPage extends StatelessWidget {
  const HistoryMonthPage({Key key, this.entries, this.monthName, this.year})
      : super(key: key);

  final List<HistoryEntry> entries;
  final String monthName;
  final String year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Histórico - $monthName $year'),
        ),
        // body: Column(
        //   children: <Widget>[
        //     Expanded(
        //         child: ListView(
        //             children: _buildEntryRecord(entries[3].entryRecord)))
        //   ],
        // )
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        entries[index].title,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Tempo total: ${TimeUtil.durationToHms(Duration(seconds: entries[index].totalTime))}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: _buildEntryRecord(
                              entries[index].entryRecord, index))
                    ],
                  )),
            );
          },
          itemCount: entries.length,
        ));
  }
}

List<Widget> _buildEntryRecord(List<DateTime> records, int index) {
  final List<Widget> listItems = <Widget>[];
  bool isPeriodEntrance = true;
  for (final DateTime record in records) {
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
      title: Text(DateFormat.Hms().format(record)),
    ));
    isPeriodEntrance = !isPeriodEntrance;
  }

  return listItems;
}
