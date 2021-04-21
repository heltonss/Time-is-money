import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Time is Money'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'time-entry');
                    },
                    child: const Text(
                      'Apontar Horas',
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            ],
          ),
        ));
  }
}
