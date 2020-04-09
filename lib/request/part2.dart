import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geohash/geohash.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood_help/styles.dart' as styles;
import 'package:neighborhood_help/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:neighborhood_help/shapedBg.dart';
import 'request.dart';

class RequestPart2 extends StatelessWidget {
  const RequestPart2({Key key}) : super(key: key);

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
        appBar: RequestStepAppBar(
          currentStep: '2',
        ),
        body: Stack(
          children: [
            ShapedBackground(),
            Center(
              child: Consumer<RequestModel>(
                builder: (context, model, child) => ListView(
                  //shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
                            'Request help',
                            style: styles.titleStyle,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum.',
                            style: styles.subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                      child: Center(
                        child: Material(
                          color: Colors.white,
                          elevation: 20,
                          borderRadius: BorderRadius.circular(15),
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              /*TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                )*/
                              /*CustomTextField(
                                name: 'Your location',
                                placeholder: 'City, postal code or address',
                                isRequired: true,
                                initialValue: model.location,
                                onEditingCompleted: (value) => model.location = value,
                              ),*/
                              RichText(
                                text: TextSpan(
                                    text: 'Your location',
                                    style: styles.textFieldNameStyle,
                                    children: [
                                      TextSpan(text: ' *', style: styles.requiredMarkStyle),
                                    ]),
                              ),
                              SizedBox(height: 10),
                              PlacesAutocompleteField(
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
                                  errorText: model.getLocationErrorText(),
                                ),
                                leading: Icon(
                                  Icons.location_searching,
                                  size: 17,
                                  color: styles.darkTextColor,
                                ),
                                trailingOnTap: () {},
                                onChanged: (val) {
                                  model.location = val;

                                  if (val == null || val.isEmpty) {
                                    model.setLocationErrorText("Please provide your location");
                                  } else {
                                    model.setLocationErrorText(null);
                                  }
                                },
                                onError: (resp) {
                                  print("Places API Autocomplete Error");
                                  print(resp.errorMessage);
                                },
                                sessionToken: model.sessionToken,
                              ),
                              SizedBox(height: 30),
                              CustomTextField(
                                name: 'Message Request',
                                placeholder: '"I need help with my groceries"',
                                isRequired: false,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                initialValue: model.message,
                                onEditingCompleted: (value) => model.message = value,
                                errorText: model.getMessageErrorText(),
                                onChanged: (val) {
                                  if (val == null || val.isEmpty) {
                                    model.setMessageErrorText(
                                        "Please provide a message with your request");
                                  } else {
                                    model.setMessageErrorText(null);
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              CheckboxRow(
                                label: 'This request is urgent',
                                value: model.getUrgent(),
                                onChanged: (val) => model.setUrgent(val),
                              ),
                              SizedBox(height: 30),
                              RaisedButton(
                                onPressed: () async {
                                  //TODO: Add loading
                                  bool invalid = false;

                                  if (model.location == null || model.location.isEmpty) {
                                    model.setLocationErrorText("Please provide your location");
                                    invalid = true;
                                  }

                                  if (model.message == null || model.message.isEmpty) {
                                    model.setMessageErrorText(
                                        "Please provide a message with your request");
                                    invalid = true;
                                  }

                                  if (invalid) return;

                                  final searchResponse =
                                      await model.getPlacesAPI().searchByText(model.location);

                                  if (searchResponse.results.length > 1)
                                    print(
                                        "Places search returned more than one location, using the first (had ${searchResponse.results.length} places)"); // TODO: Implement dialog to pick the preferred location
                                  //searchResponse.results.map((res) => res.placeId));
                                  final detailsResponse = await model
                                      .getPlacesAPI()
                                      .getDetailsByPlaceId(searchResponse.results[0].placeId,
                                          fields: ['geometry', 'formatted_address'],
                                          sessionToken: model.sessionToken);

                                  final location = detailsResponse.result.geometry.location;

                                  final data = <String, dynamic>{
                                    if (model.getContactMethod() == 'email') 'email': model.email,
                                    if (model.getContactMethod() == 'phone') 'phone': model.phone,
                                    'message': model.message,
                                    'name': model.name,
                                    'time_created': FieldValue.serverTimestamp(),
                                    'urgent': model.getUrgent(),
                                    'formatted_address': detailsResponse.result.formattedAddress,
                                    //'lat': location.lat,
                                    //'lng': location.lng,
                                    'geohash': Geohash.encode(location.lat, location.lng)
                                  };

                                  Firestore.instance.collection("requests").add(data);

                                  model.nextPart();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    SizedBox(width: 50),
                                    Text('Send Request',
                                        style: styles.introNextStyle.copyWith(color: Colors.white)),
                                    SizedBox(width: 50),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 25,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                color: styles.requestBlue,
                                elevation: 0,
                                padding: const EdgeInsets.all(16.0),
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 100)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
