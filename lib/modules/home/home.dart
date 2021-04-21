import 'package:flutter/material.dart';
import 'package:time_is_money/modules/model/user.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments as User;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Time is Money'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
                child: Center(
                    child: Text(
                  'Bem vindo: ${user.email}',
                  style: const TextStyle(fontSize: 25),
                )),
              ),
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