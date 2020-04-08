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

class VolunteerResults extends StatefulWidget {
  const VolunteerResults({Key key}) : super(key: key);

  @override
  _VolunteerResultsState createState() => _VolunteerResultsState();
}

class _VolunteerResultsState extends State<VolunteerResults> {
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
                      /*WidgetsBinding.instance.addPostFrameCallback((dur) {
                        PlacesAutocomplete.show(
                            context: context,
                            apiKey: model.apiKey,
                            sessionToken: model.sessionToken,
                            mode: Mode.fullscreen);
                      });*/
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
                          child: Material(
                            borderRadius: BorderRadius.circular(15),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: <Widget>[
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

                                      if (model.location != null && model.location.isNotEmpty) {
                                        if (model.getRadius() == 0) model.setRadius(10);

                                        model.refreshRequests();
                                      }
                                    },
                                    onError: (resp) {
                                      print("Places API Autocomplete Error");
                                      print(resp.errorMessage);
                                    },
                                    sessionToken: model.sessionToken,
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ChoiceChip(
                                        selected: model.getRadius() == 10,
                                        label: Text('10 mi'),
                                        onSelected: (val) => model.setRadius(10),
                                      ),
                                      SizedBox(width: 10),
                                      ChoiceChip(
                                        selected: model.getRadius() == 20,
                                        label: Text('20 mi'),
                                        onSelected: (val) => model.setRadius(20),
                                      ),
                                      SizedBox(width: 10),
                                      ChoiceChip(
                                        selected: model.getRadius() == 30,
                                        label: Text('30 mi'),
                                        onSelected: (val) => model.setRadius(30),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  if (model.getRequests().length > 0)
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        //mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${model.getRequests().length} requests found, sorted by proximity below:',
                                            style: styles.resultsCountStyle,
                                          ),
                                          SizedBox(height: 10)
                                        ],
                                      ),
                                    ),
                                  Container(
                                    height: 350,
                                    width: 320,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: styles.inputBorderColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: (model.getRequests().length == 0)
                                        ? (model.location == null || model.location.isEmpty)
                                            ? Container()
                                            : Center(
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: CircularProgressIndicator(),
                                                ),
                                              )
                                        : Scrollbar(
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: model.getRequests().length + 1,
                                              itemBuilder: (context, index) => (index ==
                                                      model.getRequests().length)
                                                  ? Container()
                                                  : ListTile(
                                                      title: Row(
                                                        children: [
                                                          Text(
                                                              '${model.getRequests()[index].data['name']}'),
                                                          SizedBox(width: 5),
                                                          if (model
                                                              .getRequests()[index]
                                                              .data['urgent'] as bool)
                                                            Chip(
                                                              avatar:
                                                                  Icon(Icons.access_time, size: 18),
                                                              label: Text('Urgent'),
                                                              backgroundColor: styles.urgentColor,
                                                              labelPadding: EdgeInsets.only(
                                                                  left: 2.5, right: 5),
                                                            ),
                                                        ],
                                                      ),
                                                      subtitle: Text(
                                                          '${model.getRequests()[index].data['message']}'),
                                                      onTap: () => model.selectRequest(
                                                          model.getRequests()[index]),
                                                    ),
                                              separatorBuilder: (context, index) => Divider(),
                                            ),
                                          ),
                                  )
                                ],
                              ),
                            ),
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
