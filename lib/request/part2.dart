import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood_help/styles.dart' as styles;
import 'package:neighborhood_help/textfield.dart';

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
                          SizedBox(height: 5),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum.',
                            style: styles.subtitleStyle.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
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
                              CustomTextField(
                                name: 'Your location',
                                placeholder: 'City, postal code or address',
                                isRequired: true,
                                initialValue: model.location,
                                onEditingCompleted: (value) => model.location = value,
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
                              ),
                              SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      text: 'When do you need it by?',
                                      style: styles.textFieldNameStyle,
                                      children: [
                                        TextSpan(text: ' *', style: styles.requiredMarkStyle),
                                      ],
                                    ),
                                  ),
                                  RadioRow(
                                    label: '24h',
                                    value: 'phone',
                                    groupValue: model.getContactMethod(),
                                    onChanged: (val) => model.setContactMethod(val),
                                  ),
                                  RadioRow(
                                    label: '2 days',
                                    value: 'email',
                                    groupValue: model.getContactMethod(),
                                    onChanged: (val) => model.setContactMethod(val),
                                  ),
                                  RadioRow(
                                    label: '1 week',
                                    value: 'other',
                                    groupValue: model.getContactMethod(),
                                    onChanged: (val) => model.setContactMethod(val),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              RaisedButton(
                                onPressed: () => model.nextPart(),
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
                    SizedBox(height: 100) // Marking page dirty
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
