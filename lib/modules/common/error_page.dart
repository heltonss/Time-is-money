import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorPage extends StatelessWidget {
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
                  Icons.error,
                  size: 150,
                  color: Colors.redAccent,
                ),
              ),
              const Text(
                'Não foi possível carregar o App',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.redAccent, fontSize: 40),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(width: 150, height: 50),
                      child: ElevatedButton(
                          style: ButtonStyle(backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.red;
                              }
                              return Colors.redAccent;
                            },
                          )),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: const Text('Sair',
                              style: TextStyle(fontSize: 20)))))
            ],
          ),
        ),
      ),
    );
  }
}
