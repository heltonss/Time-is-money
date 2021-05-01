import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_is_money/modules/common/history_error_page.dart';
import 'package:time_is_money/modules/history/entities/history_entry.dart';
import 'package:time_is_money/modules/history/history_dao.dart';
import 'package:time_is_money/modules/model/user.dart';

import 'history_year_body.dart';

class HistoryYearPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryYearPageState();
  }
}

class _HistoryYearPageState extends State<HistoryYearPage> {
  HistoryEntry baseEntries;

  HistoryDAO historyDAO;

  @override
  Widget build(BuildContext context) {
    historyDAO = HistoryDAO(firestore: FirebaseFirestore.instance);
    return buildPage();
  }

  FutureBuilder<HistoryEntry> buildPage() {
    return FutureBuilder<HistoryEntry>(
        future: getEntries(),
        builder: (BuildContext ctx, AsyncSnapshot<HistoryEntry> snap) {
          if (snap.hasError) return HistoryErrorPage();
          if (snap.connectionState == ConnectionState.done) {
            baseEntries = snap.data;
          }
          return buildTimeEntryPage(context: ctx);
        });
  }

  Widget buildTimeEntryPage({BuildContext context}) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Histórico - 2021'),
        ),
        body: HistoryYearBody(
          yearData: baseEntries,
          isLoading: baseEntries == null,
        ));
  }

  Future<HistoryEntry> getEntries() async {
    final User loggedUser = ModalRoute.of(context).settings.arguments as User;
    final DateTime currentDate = DateTime.now();

    return historyDAO.getTimePerYear('${loggedUser.email}_${currentDate.year}');
  }
}
