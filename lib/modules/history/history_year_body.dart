import 'package:flutter/material.dart';
import 'package:time_is_money/modules/history/history_month_page.dart';
import 'package:time_is_money/modules/utils/time_util.dart';

import 'entities/history_entry.dart';

class HistoryYearBody extends StatelessWidget {
  const HistoryYearBody({
    Key key,
    this.yearData,
    this.isLoading,
  }) : super(key: key);

  final HistoryEntry yearData;
  final bool isLoading;

  Widget _buildListItem(BuildContext context, int index) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return HistoryMonthPage(
                    entries: yearData.subEntries[index].subEntries,
                    monthName: yearData.subEntries[index].title,
                    year: yearData.title);
              },
            ),
          );
        },
        child: Card(
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(yearData.subEntries[index].title,
                      style: const TextStyle(fontSize: 18)),
                  Text(
                      'Tempo total: ${TimeUtil.durationToHms(Duration(seconds: yearData.subEntries[index].totalTime))}',
                      style: const TextStyle(fontSize: 16))
                ],
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return ListView.builder(
      itemBuilder: _buildListItem,
      itemCount: yearData.subEntries.length,
    );
  }
}
