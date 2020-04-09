import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geohash/geohash.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood_help/styles.dart' as styles;
import 'package:google_maps_webservice/places.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:neighborhood_help/widgets.dart';

import 'intro.dart';
import 'results.dart';
import 'confirmation.dart';

class VolunteerModel extends ChangeNotifier {
  VolunteerModel() {
    _initApi();
  }

  _initApi() {
    apiKey = "AIzaSyAykE-8rdRtJLj2Rads7kGKpX8KEYxmnxc";

    _places = GoogleMapsPlaces(apiKey: apiKey);

    validateSessionToken();
  }

  void validateSessionToken() {
    if (sessionToken == null) {
      sessionToken = uuid.v4();
    }
  }

  String apiKey;
  GoogleMapsPlaces _places;
  static final uuid = Uuid();
  String sessionToken;

  GoogleMapsPlaces getPlacesAPI() => _places;

  String location;

  double _radius = 0;
  List<DocumentSnapshot> _requests = [];
  DocumentSnapshot _currentRequest;
  bool _confirmed = false;

  double getRadius() => _radius;

  void setRadius(double newValue) {
    if (_radius == newValue) return;
    _radius = newValue;

    refreshRequests();
    // /notifyListeners();
  }

  List<DocumentSnapshot> getRequests() => _requests;

  void setRequests(List<DocumentSnapshot> newValue) {
    _requests = newValue;

    notifyListeners();
  }

  DocumentSnapshot getCurrentRequest() => _currentRequest;

  void setCurrentRequest(DocumentSnapshot newValue) {
    _currentRequest = newValue;

    notifyListeners();
  }

  bool getConfirmed() => _confirmed;

  void setConfirmed(bool newValue) {
    _confirmed = newValue;

    notifyListeners();
  }

  Widget _currentPart = _partsMap[0];
  int _currentPartIndex = 0;

  static const List<Widget> _partsMap = [
    VolunteerIntro(),
    VolunteerResults(),
    VolunteerConfirmation(),
  ];

  Widget getCurrentPart() {
    return _currentPart;
  }

  void _setCurrentPart(Widget newPart) {
    _currentPart = newPart;
    _confirmed = false;
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

  Future<void> refreshRequests() async {
    if (this.location == null || this.location.isEmpty) return;
    setRequests([]); // Trigger loading
    print('request refresh triggered');

    final searchResponse = await getPlacesAPI().searchByText(this.location);

    final detailsResponse = await getPlacesAPI().getDetailsByPlaceId(
        searchResponse.results[0].placeId,
        fields: ['geometry', 'formatted_address'],
        sessionToken: sessionToken);

    final location = detailsResponse.result.geometry.location;

    final snapshot =
        await queryDocumentsInRange(lat: location.lat, lng: location.lng, radius: getRadius());
    setRequests(snapshot.documents);

    //notifyListeners();
  }

  Future<void> selectRequest(DocumentSnapshot doc) async {
    if (_currentPartIndex != 1) return; // Can only select requests on the results page

    setCurrentRequest(doc);

    nextPart();
  }

  String getContactMethod() {
    if (_currentPartIndex != 2) return 'Error';

    final data = getCurrentRequest().data;

    if (data['email'] != null) {
      return data['email'];
    } else if (data['phone'] != null) {
      return PhoneNumberTextInputFormatter()
          .formatEditUpdate(null, TextEditingValue(text: '${data['phone']}'))
          .text;
    } else {
      return 'No contact method found';
    }
  }

  String getContactVerb() {
    if (_currentPartIndex != 2) return 'Error';

    final data = getCurrentRequest().data;

    if (data['email'] != null) {
      return 'Email';
    } else if (data['phone'] != null) {
      return 'Call';
    } else {
      return 'Contact';
    }
  }

  IconData getContactIcon() {
    if (_currentPartIndex != 2) return null;

    final data = getCurrentRequest().data;

    if (data['email'] != null) {
      return Icons.email;
    } else if (data['phone'] != null) {
      return Icons.phone;
    } else {
      return null;
    }
  }

  Future<void> initiateContact(BuildContext context, {bool secondary = false}) async {
    if (_currentPartIndex != 2) return;

    final data = getCurrentRequest().data;

    if (data['email'] != null) {
      if (secondary) return; // Secondary mail action not possible (this should never even execute)
      if (await canLaunch('mailto:${data['email']}')) {
        launch('mailto:${data['email']}');
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Failed to launch mail app, please open it manually')));
      }
    } else if (data['phone'] != null) {
      final actionUri = (secondary) ? 'sms:${data['phone']}' : 'tel:${data['phone']}';
      if (await canLaunch(actionUri)) {
        launch(actionUri);
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Failed to launch phone app, please open it manually')));
      }
    } else {
      ;
    }
  }

  bool canInitiateSecondaryContact() {
    final data = getCurrentRequest().data;

    return data['email'] == null && data['phone'] != null;
  }

  // Query Helpers
  final _latConst = 0.0144927536231884; // degrees latitude per mile
  final _lngConst = 0.0181818181818182; // degrees longitude per mile

  Future<QuerySnapshot> queryDocumentsInRange(
      {@required double lat,
      @required double lng,
      @required double radius,
      CollectionReference collection}) async {
    final lowerLat = lat - (_latConst * radius);
    final lowerLng = lng - (_lngConst * radius);

    final upperLat = lat + (_latConst * radius);
    final upperLng = lng + (_lngConst * radius);

    final lowerHash = Geohash.encode(lowerLat, lowerLng);
    final upperHash = Geohash.encode(upperLat, upperLng);

    if (collection == null) collection = Firestore.instance.collection('requests');

    final query = collection
        .where('geohash', isGreaterThanOrEqualTo: lowerHash, isLessThanOrEqualTo: upperHash)
        .orderBy('geohash', descending: true)
        .orderBy('urgent', descending: true);

    final snapshot = await query.getDocuments();
    return snapshot;
  }
}

class VolunteerPage extends StatefulWidget {
  VolunteerPage({Key key}) : super(key: key);

  @override
  _VolunteerPageState createState() => _VolunteerPageState();
}

class _VolunteerPageState extends State<VolunteerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()), // On tap close any keyboards
        child: ChangeNotifierProvider<VolunteerModel>(
          create: (context) => VolunteerModel(),
          child: Builder(
            builder: (context) => AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              /*transitionBuilder: (child, animation) => SlideTransition(
                position: animation.drive(
                  Tween(begin: Offset(1, 0), end: Offset.zero),
                ),
                child: child,
              ),*/
              child: Provider.of<VolunteerModel>(context).getCurrentPart(),
            ),
          ),
        ),
      ),
    );
  }
}

class VolunteerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VolunteerAppBar({this.title, this.getTitle, this.isDirectExit = _defaultFalse, Key key})
      : assert(title != null || getTitle != null),
        assert(isDirectExit != null),
        super(key: key);

  final String title;
  final Function(VolunteerModel) getTitle;
  // Determines if there should be a back button or a close button
  final Function(VolunteerModel) isDirectExit;

  static _defaultFalse(model) => false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: styles.requestBlue,
        child: Consumer<VolunteerModel>(
          builder: (context, model, child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(children: [
              IconButton(
                icon: Icon(
                  (isDirectExit(model)) ? Icons.close : Icons.arrow_back,
                  color: Colors.white,
                  size: 23,
                ),
                onPressed: () => (isDirectExit(model)) ? Navigator.pop(context) : model.previousPart(),
              ),
              Text(
                (title != null) ? title : getTitle(model),
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
