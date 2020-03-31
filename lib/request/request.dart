import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'intro.dart';
import 'part1.dart';
import 'part2.dart';
import 'part3.dart';

class RequestModel extends ChangeNotifier {
  Widget _currentPart = _partsMap[0];
  int _currentPartIndex = 0;

  static const List<Widget> _partsMap = [
    RequestIntro(),
    RequestPart1(),
    RequestPart2(),
    RequestPart3(),
  ];

  Widget getCurrentPart() => _currentPart;

  void _setCurrentPart(Widget newPart) {
    _currentPart = newPart;

    notifyListeners();
  }

  void nextPart() {
    _currentPartIndex++;

    _setCurrentPart(_partsMap[_currentPartIndex]);
  }

  void previousPart() {
    _currentPartIndex--;

    _setCurrentPart(_partsMap[_currentPartIndex]);
  }
}

class RequestPage extends StatefulWidget {
  RequestPage({Key key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RequestModel>(
        create: (context) => RequestModel(),
        child: Builder(
          builder: (context) => AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => SlideTransition(
              position: animation.drive(
                Tween(begin: Offset(1, 0), end: Offset.zero),
              ),
              child: child,
            ),
            child: Provider.of<RequestModel>(context).getCurrentPart(),
          ),
        ),
      ),
    );
  }
}
