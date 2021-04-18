import 'package:flutter/material.dart';
import 'package:time_is_money/modules/create_user/create_user.dart';
import 'package:time_is_money/modules/login/login.dart';
import 'package:time_is_money/modules/time_entry/time_entry_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Time is money',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => Login(),
          'time-entry': (BuildContext context) => TimeEntryPage(),
          'create-user':(BuildContext context) => CreateUser()
          });
  }
}
