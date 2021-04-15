import 'package:flutter/material.dart';

class TimeEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time is Money',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Time is Money'),
        ),
        body: const Center(
          child: Text('Tudo calmo por aqui!'),
        ),
        floatingActionButton: Container(
          height: 100.0,
          width: 100.0,
          child: FittedBox(
              child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.red,
            child: const Icon(
              Icons.fingerprint,
            ),
          )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
