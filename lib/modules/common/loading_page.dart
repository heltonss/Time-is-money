import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 50, bottom: 50),
                child: const Icon(
                  Icons.access_time,
                  size: 150,
                  color: Colors.blueAccent,
                ),
              ),
              const Text(
                'Time is Money',
                style: TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50, bottom: 50),
                child: const CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
