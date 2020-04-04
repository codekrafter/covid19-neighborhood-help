import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood_help/styles.dart' as styles;
import 'package:neighborhood_help/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'requestBg.dart';
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
        appBar: RequestStepAppBar(
          currentStep: '2',
        ),
        body: Stack(
          children: [
            RequestBackground(),
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
                                label: 'As soon as possible',
                                value: model.getUrgent(),
                                onChanged: (val) => model.setUrgent(val),
                              ),
                              SizedBox(height: 30),
                              RaisedButton(
                                onPressed: () async {
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

                                  //TODO: Integrate Maps Places Search and Details API
                                  final searchResponse =
                                      await model.getPlacesAPI().searchByText(model.location);

                                  if (searchResponse.results.length > 1)
                                    print(
                                        "Places search returned more than one location, using the first (had ${searchResponse.results.length} places)"); // TODO: Implement dialog to pick the preferred location
                                  //searchResponse.results.map((res) => res.placeId));
                                  final detailsResponse = await model
                                      .getPlacesAPI()
                                      .getDetailsByPlaceId(searchResponse.results[0].placeId,
                                          fields: ['address_component', 'formatted_address'],
                                          sessionToken: model.sessionToken);
                                  print(detailsResponse.toJson().toString());
                                  //detailsResponse.result.addressComponents
                                  //    .where((com) => !com.types.contains(''));
                                  //print(detailsResponse.result.addressComponents[0].types[0]);
                                  // final postalCode = addrComp.firstWhere((com) => com.types[0] == "postal_code").longName;
                                  // request.where("postalCode", "==", postalCode).where("country", "==", country)
                                  // request.get();

                                  // Firestore.instance
                                  //     .collection("requests")
                                  //     .add(detailsResponse.result.addressComponents);
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
