import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryPageState();
  }
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    //Navigator.pushNamed(context, 'time-entry', arguments: user);
                  },
                  child: const Text(
                    'Dia',
                    style: TextStyle(fontSize: 16),
                  )),
            ),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  //Navigator.pushNamed(context, 'time-entry', arguments: user);
                },
                child: const Text(
                  'Semana',
                  style: TextStyle(fontSize: 16),
                )),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  //Navigator.pushNamed(context, 'time-entry', arguments: user);
                },
                child: const Text(
                  'Mês',
                  style: TextStyle(fontSize: 16),
                )),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  //Navigator.pushNamed(context, 'time-entry', arguments: user);
                },
                child: const Text(
                  'Ano',
                  style: TextStyle(fontSize: 16),
                )),
          )
        ],
      ),
    ));
  }
}
