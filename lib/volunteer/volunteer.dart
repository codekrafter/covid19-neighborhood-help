import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geohash/geohash.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood_help/styles.dart' as styles;
import 'package:google_maps_webservice/places.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import 'intro.dart';
import 'results.dart';

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

  Widget _currentPart = _partsMap[0];
  int _currentPartIndex = 0;

  static const List<Widget> _partsMap = [
    VolunteerIntro(),
    VolunteerResults(),
  ];

  Widget getCurrentPart() {
    return _currentPart;
  }

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

  void refreshRequests() async {
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
    print(snapshot.documents.length);
    setRequests(snapshot.documents);

    //notifyListeners();
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

    print('lower: $lowerHash');
    print('upper: $upperHash');

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
  const VolunteerAppBar({@required this.title, Key key})
      : assert(title != null),
        super(key: key);

  final String title;

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
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 23,
                ),
                onPressed: () => model.previousPart(),
              ),
              Text(
                title,
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
