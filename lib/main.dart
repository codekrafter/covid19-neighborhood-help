import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:geohash/geohash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterI18nDelegate(
          translationLoader: NetworkFileTranslationLoader(
            baseUri: Uri.https("neighbourhood-help.web.app", "/locales/"),
          ),
        )
      ],
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final page = routes[settings.name](context);

        if (page != null) {
          return CupertinoPageRoute(builder: (context) => routes[settings.name](context));
        } else {
          return null;
        }
      },
    );
  }
}
