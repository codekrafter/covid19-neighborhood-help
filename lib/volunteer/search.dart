import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood_help/styles.dart' as styles;
import 'package:neighborhood_help/widgets.dart';

import 'package:neighborhood_help/shapedBg.dart';
import 'volunteer.dart';

class VolunteerSearch extends StatefulWidget {
  const VolunteerSearch({Key key}) : super(key: key);

  @override
  _VolunteerSearchState createState() => _VolunteerSearchState();
}

class _VolunteerSearchState extends State<VolunteerSearch> {
  bool promptedForLocation = false;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: styles.requestBlue,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: styles.requestBlue,
        appBar: VolunteerAppBar(
          title: 'Search',
        ),
        body: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: Stack(
            children: [
              ShapedBackground(),
              Center(
                child: Consumer<VolunteerModel>(
                  builder: (context, model, child) {
                    if (!promptedForLocation) {
                      promptedForLocation = true;
                      WidgetsBinding.instance.addPostFrameCallback((dur) {
                        PlacesAutocomplete.show(
                            context: context,
                            apiKey: model.apiKey,
                            sessionToken: model.sessionToken,
                            mode: Mode.fullscreen);
                      });
                    }

                    return ListView(
                      //shrinkWrap: true,
                      //physics: NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*Text(
                                'Step 1 of 3',
                                style: styles.stepHeaderStyle,
                              ),
                              SizedBox(
                                height: 10
                              ),*/
                              Text(
                                'Find people nearby',
                                style: styles.titleStyle,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum.',
                                style: styles.subtitleStyle,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          child: Column(
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(15),
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: PlacesAutocompleteField(
                                    apiKey: model.apiKey,
                                    mode: Mode.overlay,
                                    inputDecoration: InputDecoration(
                                      border: customTextFieldNormalBorder,
                                      enabledBorder: customTextFieldNormalBorder,
                                      focusedBorder: customTextFieldNormalBorder.copyWith(
                                          borderSide: BorderSide(color: styles.requestBlue)),
                                      hintText: 'City, postal code or address',
                                      hintStyle: TextStyle(color: styles.inputBorderColor),
                                      contentPadding: EdgeInsets.fromLTRB(15, 5, 3, 3),
                                      //errorText: model.getLocationErrorText(),
                                    ),
                                    leading: Icon(
                                      Icons.location_searching,
                                      size: 17,
                                      color: styles.darkTextColor,
                                    ),
                                    trailingOnTap: () {},
                                    onChanged: (val) {
                                      model.location = val;
                                    },
                                    onError: (resp) {
                                      print("Places API Autocomplete Error");
                                      print(resp.errorMessage);
                                    },
                                    sessionToken: model.sessionToken,
                                  ),
                                ),
                              ),
                              SizedBox(height: 1),
                              Material(
                                child: Column(
                                  children: <Widget>[
                                    Slider(
                                      min: 0,
                                      max: 20,
                                      value: model.getRadius(),
                                      onChanged: (val) {
                                        model.setRadius(val);
                                      },
                                      onChangeEnd: (val) async {
                                        if (model.location != null && model.location.isNotEmpty) {
                                          final searchResults = await model
                                              .getPlacesAPI()
                                              .searchByText(model.location);

                                          final detailsResults = await model
                                              .getPlacesAPI()
                                              .getDetailsByPlaceId(searchResults.results[0].placeId,
                                                  fields: ['geometry', 'formatted_address'],
                                                  sessionToken: model.sessionToken);
                                          model.sessionToken = null;
                                          model.validateSessionToken();

                                          final loc = detailsResults.result.geometry.location;

                                          final query = await model.queryDocumentsInRange(
                                              lat: loc.lat, lng: loc.lng, radius: val);

                                          query.documents
                                              .map((doc) => doc.data['message'])
                                              .forEach(print);
                                        }
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    Text('Radius: ${model.getRadius()}')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
