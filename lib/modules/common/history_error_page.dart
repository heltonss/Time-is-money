import 'package:flutter/material.dart';

class HistoryErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Time is Money'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 50, bottom: 50),
                child: const Icon(
                  Icons.error,
                  size: 150,
                  color: Colors.redAccent,
                ),
              ),
              const Text(
                'Não foi possível carregar dados de histórico, verifique se você possui pontos cadastrados.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.redAccent, fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
