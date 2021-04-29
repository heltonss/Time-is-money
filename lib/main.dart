import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'modules/about/about.dart';
import 'modules/common/error_page.dart';
import 'modules/common/loading_page.dart';
import 'modules/create_user/create_user.dart';
import 'modules/home/home.dart';
import 'modules/login/login.dart';
import 'modules/time_entry/time_entry_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return ErrorPage();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              title: 'Time is money',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              initialRoute: '/',
              routes: <String, WidgetBuilder>{
                '/': (BuildContext context) => Login(),
                'home': (BuildContext context) => Home(),
                'about': (BuildContext context) => About(),
                'time-entry': (BuildContext context) => TimeEntryPage(),
                'create-user': (BuildContext context) => CreateUser()
              });
        }
        return LoadingPage();
      },
    );
  }
}
