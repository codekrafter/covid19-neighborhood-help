import 'package:country_pickers/country.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood_help/styles.dart' as styles;
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_number_input/src/utils/formatter/as_you_type_formatter.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'dart:io' show Platform;

import 'intro.dart';
import 'part1.dart';
import 'part2.dart';
import 'part3.dart';

class RequestModel extends ChangeNotifier {
  RequestModel() {
    _getAPIKey();

    resetToDefaults();
  }

  void _getAPIKey() async {
    //final options = await FirebaseApp.instance.options;
    //apiKey = options.apiKey;
    /*if (Platform.isIOS) {
      apiKey = "AIzaSyCdslN2f7ELqDonpx1pfkwe1lYNiWVUimg";
    } else if (Platform.isAndroid) {
      apiKey = "AIzaSyCPMPccYO5qNskPLUCxWWe_yPm3Q-iA3kU";
    } else {
      print('Unknown Platform');
    }*/
    apiKey = "AIzaSyDLJndrvUwS26MHl9-1XYoU8c3RwzaLAHo";

    _places = GoogleMapsPlaces(apiKey: apiKey);

    notifyListeners();
  }

  void resetToDefaults() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final defaultsSnapshot =
        await Firestore.instance.collection("users").document(currentUser.uid).get();
    final data = defaultsSnapshot.data;
    print(data);
    _contactMethod = data['contact_method'] ?? '';
    //_countryCode = data['country_code'] ?? '1';
    name = data['name'] ?? null;
    email = data['email'] ?? null;
    phone = data['phone'] ?? null;

    // fill in formatted number if a default number is saved
    if (phone != null) {
      //final localNumber = phone.toString().substring(_countryCode.length);
      //TODO: parse stored number to displayed number
      //AsYouTypeFormatter()
      //numberFieldValue = PhoneInputFormatter
    }

    notifyListeners();
  }

  void saveDefaults() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final data = {
      'contact_method': _contactMethod, // Should never be null
      //'country_code': _countryCode, // Should never be null
      if (name != null)
        'name': name,
      if (email != null)
        'email': email,
      if (phone != null)
        'phone': phone
    };

    await Firestore.instance.collection("users").document(currentUser.uid).setData(data, merge: true);
  }

  void validateSessionToken() {
    if (sessionToken == null) {
      sessionToken = uuid.v4();
    }

    print(sessionToken);
  }

  Widget _currentPart = _partsMap[0];
  int _currentPartIndex = 0;

  String apiKey;
  GoogleMapsPlaces _places;
  static final uuid = Uuid();
  String sessionToken;

  GoogleMapsPlaces getPlacesAPI() => _places;

  TextEditingController _numberController;

  TextEditingController getNumberController() {
    if (_numberController == null)
      _numberController = TextEditingController(text: numberFieldValue ?? "");

    return _numberController;
  }

  // Members just used for form fields, so no need to have a rich setter
  String name;
  String email;
  int phone;
  Country phoneCountry;
  String location;
  String message;

  // Not to be serialized, just used to keep the user's phone in a formatted state
  String numberFieldValue = '';

  // Form field values that need rich interaction
  String _contactMethod = '';
  //String _countryCode = '1';
  String _nameErrorText;
  String _contactMethodErrorText;
  bool _urgent = false;
  String _locationErrorText;
  String _messageErrorText;

  String getContactMethod() => _contactMethod;

  void setContactMethod(String newValue) {
    if (_contactMethod == "phone") _numberController = null;
    _contactMethod = newValue;

    notifyListeners();
  }

  String getContactDetails() {
    if (_contactMethod == "phone") {
      return "$phone";
    } else {
      return email;
    }
  }

  // String getCountryCode() => _countryCode;

  // void setCountryCode(String newValue) {
  //   _countryCode = newValue;
  //   print('new country code: $newValue');

  //   notifyListeners();
  // }

  String getNameErrorText() => _nameErrorText;

  void setNameErrorText(String newValue) {
    _nameErrorText = newValue;

    notifyListeners();
  }

  String getContactMethodErrorText() => _contactMethodErrorText;

  void setContactMethodErrorText(String newValue) {
    _contactMethodErrorText = newValue;

    notifyListeners();
  }

  bool getUrgent() => _urgent;

  void setUrgent(bool newValue) {
    _urgent = newValue;

    notifyListeners();
  }

  String getLocationErrorText() => _locationErrorText;

  void setLocationErrorText(String newValue) {
    _locationErrorText = newValue;

    notifyListeners();
  }

  String getMessageErrorText() => _messageErrorText;

  void setMessageErrorText(String newValue) {
    _messageErrorText = newValue;

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
    if (_currentPartIndex == 2) {
      // If moving away from part 1, remove the reference to the number text controller
      _numberController = null;

      // If moving to part 2 make sure we have a valid session token
      validateSessionToken();
    }
  }

  void previousPart() {
    _currentPartIndex--;

    _setCurrentPart(_partsMap[_currentPartIndex]);
    if (_currentPartIndex == 0)
      _numberController =
          null; // If moving away from part 1, remove the reference to the number text controller
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
                onPressed: () {
                  model.previousPart();
                  FocusScope.of(context).requestFocus(FocusNode());
                },
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
