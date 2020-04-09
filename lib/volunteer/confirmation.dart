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

class VolunteerConfirmation extends StatefulWidget {
  const VolunteerConfirmation({Key key}) : super(key: key);

  @override
  _VolunteerConfirmationState createState() => _VolunteerConfirmationState();
}

class _VolunteerConfirmationState extends State<VolunteerConfirmation> {
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
          getTitle: (model) => model.getConfirmed() ? model.getCurrentRequest().data['name'] : 'Search',
          isDirectExit: (model) => model.getConfirmed(),
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
                      physics: ClampingScrollPhysics(),
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
                                (!model.getConfirmed()) ? 'Can you help ${model.getCurrentRequest().data['name']}?' : 'Please reach out to ${model.getCurrentRequest().data['name']}',
                                style: styles.titleStyle,
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
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  Column(
                                    // Extra column to strech just the message
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Material(
                                        color: styles.inputBorderColor,
                                        elevation: 0,
                                        borderRadius: BorderRadius.circular(3),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            model.getCurrentRequest().data['message'],
                                            //style: styles.contactFeatureStyle,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  if (model.getCurrentRequest().data['urgent'] as bool)
                                    Chip(
                                      avatar: Icon(Icons.access_time, size: 18),
                                      label: Text('Urgent'),
                                      backgroundColor: styles.urgentColor,
                                      labelPadding: EdgeInsets.only(left: 2.5, right: 5),
                                    ),
                                  if (model.getCurrentRequest().data['urgent'] as bool)
                                    SizedBox(height: 20),
                                  Divider(),
                                  SizedBox(height: 20),
                                  AnimatedSwitcher(
                                    duration: Duration(seconds: 1),
                                    child: (model.getConfirmed())
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                'Reach out via',
                                                style: styles.postTitleStyle,
                                              ),
                                              SizedBox(height: 15),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                                child: SelectableText(
                                                  model.getContactMethod(),
                                                  style: styles.postBodyStyle,
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              RaisedButton(
                                                onPressed: () => model.initiateContact(context),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Icon(
                                                      model.getContactIcon(),
                                                      size: 25,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(model.getContactVerb(),
                                                        style: styles.introNextStyle
                                                            .copyWith(color: Colors.white)),
                                                  ],
                                                ),
                                                color: styles.requestBlue,
                                                elevation: 0,
                                                padding: const EdgeInsets.all(16.0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)),
                                              ),
                                              SizedBox(height: 15),
                                              if(model.canInitiateSecondaryContact()) RaisedButton(
                                                onPressed: () => model.initiateContact(context, secondary: true),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.sms,
                                                      size: 25,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text('Text',
                                                        style: styles.introNextStyle
                                                            .copyWith(color: Colors.white)),
                                                  ],
                                                ),
                                                color: styles.requestBlue,
                                                elevation: 0,
                                                padding: const EdgeInsets.all(16.0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              RaisedButton(
                                                onPressed: () => model.setConfirmed(true),
                                                child: Text('Confirm Acceptance',
                                                    style: styles.introNextStyle
                                                        .copyWith(color: Colors.white)),
                                                color: styles.requestBlue,
                                                elevation: 0,
                                                padding: const EdgeInsets.all(16.0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)),
                                              ),
                                              SizedBox(height: 10),
                                              OutlineButton(
                                                onPressed: () async {
                                                  model.previousPart();
                                                  await model.refreshRequests();
                                                  model.setCurrentRequest(null);
                                                },
                                                child: Text('Cancel', style: styles.introNextStyle),
                                                color: styles.requestBlue,
                                                borderSide: BorderSide(
                                                  color: styles.requestBlue,
                                                  style: BorderStyle.solid,
                                                  width: 2,
                                                ),
                                                padding: const EdgeInsets.all(16.0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)),
                                              ),
                                            ],
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
