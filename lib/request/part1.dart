import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood_help/styles.dart' as styles;
import 'package:neighborhood_help/textfield.dart';

import 'requestBg.dart';
import 'request.dart';

class RequestPart1 extends StatelessWidget {
  const RequestPart1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: styles.requestBlue,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        backgroundColor: styles.requestBlue,
        appBar: RequestStepAppBar(
          currentStep: '1',
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
                    /*SizedBox(
                        height: 10,
                      ),
                      Padding(
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
                            'Step 1 of 3',
                            style: styles.stepHeaderStyle,
                          )
                        ]),
                      ),*/
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
                            'Fill in your information',
                            style: styles.titleStyle,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'We need your basic information so that it\'s easier for someone to help you',
                            style: styles.subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                      child: Center(
                        child: Material(
                          color: Colors.white,
                          elevation: 20,
                          borderRadius: BorderRadius.circular(15),
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              /*TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                )*/
                              CustomTextField(
                                name: 'Your name',
                                placeholder: 'INSERT HINT HERE',
                                isRequired: true,
                                initialValue: model.location,
                                onEditingCompleted: (value) => model.location = value,
                              ),
                              SizedBox(height: 30),
                              // Pretty much useless to add a column in a column but I added it anyways for abstraction
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      text: 'Contact Method',
                                      style: styles.textFieldNameStyle,
                                      children: [
                                        TextSpan(text: ' *', style: styles.requiredMarkStyle),
                                      ],
                                    ),
                                  ),
                                  RadioRow(
                                    label: 'Phone',
                                    value: 'phone',
                                    groupValue: model.getContactMethod(),
                                    onChanged: (val) => model.setContactMethod(val),
                                  ),
                                  RadioRow(
                                    label: 'Email',
                                    value: 'email',
                                    groupValue: model.getContactMethod(),
                                    onChanged: (val) => model.setContactMethod(val),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              PhoneNumberField(
                                countryCode: model.getCountryCode(),
                                onSelected: (country) => model.setCountryCode(country.phoneCode),
                              ),
                              SizedBox(height: 30),
                              RaisedButton(
                                onPressed: () => model.nextPart(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    SizedBox(width: 70),
                                    Text('Next Step', style: styles.introNextStyle.copyWith(color: Colors.white)),
                                    SizedBox(width: 70),
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
