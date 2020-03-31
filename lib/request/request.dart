import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood_help/styles.dart' as styles;

import 'intro.dart';
import 'part1.dart';
import 'part2.dart';
import 'part3.dart';

class RequestModel extends ChangeNotifier {
  Widget _currentPart = _partsMap[0];
  int _currentPartIndex = 0;

  // Members just used for form fields, so no need to have a rich setter
  String name;
  String email;
  int phone;
  String location;
  String message;
  String urgency;

  // Form field values that need rich interaction
  String _contactMethod = "";
  String _countryCode = '1';

  String getContactMethod() => _contactMethod;

  void setContactMethod(String newValue) {
    _contactMethod = newValue;

    notifyListeners();
  }

  String getCountryCode() => _countryCode;

  void setCountryCode(String newValue) {
    _countryCode = newValue;
    print('new country code: $newValue');
    notifyListeners();
  }

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()), // On tap close any keyboards
        child: ChangeNotifierProvider<RequestModel>(
          create: (context) => RequestModel(),
          child: Builder(
            builder: (context) => AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              /*transitionBuilder: (child, animation) => SlideTransition(
                position: animation.drive(
                  Tween(begin: Offset(1, 0), end: Offset.zero),
                ),
                child: child,
              ),*/
              child: Provider.of<RequestModel>(context).getCurrentPart(),
            ),
          ),
        ),
      ),
    );
  }
}

class RequestStepAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RequestStepAppBar({@required this.currentStep, this.totalSteps = '3', Key key})
      : assert(currentStep != null),
        assert(totalSteps != null),
        super(key: key);

  final String currentStep;
  final String totalSteps;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: styles.requestBlue,
        child: Consumer<RequestModel>(
          builder: (context, model, child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 23,
                ),
                onPressed: () => model.previousPart(),
              ),
              Text(
                'Step $currentStep of $totalSteps',
                style: styles.stepHeaderStyle,
              )
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}

class RadioRow extends StatelessWidget {
  const RadioRow(
      {@required this.label, @required this.value, @required this.groupValue, this.onChanged, key})
      : assert(label != null),
        assert(value != null),
        assert(groupValue != null),
        super(key: key);

  final String label;
  final String value;
  final String groupValue;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: (onChanged != null) ? onChanged : (val) {},
          activeColor: styles.requestBlue,
        ),
        Text(label),
      ],
    );
  }
}
