import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'request/request.dart';
import 'volunteer/volunteer.dart';

import 'home.dart';
import 'styles.dart' as styles;

Map<String, Function(BuildContext)> get routes => {
      '/': (context) => HomePage(),
      '/request': (context) => RequestPage(),
      '/volunteer': (context) => VolunteerPage(),
    };

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neighborhood Help',
      theme: ThemeData(
        primaryColor: styles.requestBlue,
        accentColor: styles.requestBlue,
        cursorColor: styles.requestBlue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) =>
          CupertinoPageRoute(builder: (context) => routes[settings.name](context)),
    );
  }
}
