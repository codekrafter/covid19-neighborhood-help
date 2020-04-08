import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:neighborhood_help/styles.dart' as styles;
import 'package:neighborhood_help/widgets.dart';

import 'package:neighborhood_help/shapedBg.dart';
import 'request.dart';

class RequestPart1 extends StatefulWidget {
  const RequestPart1({Key key}) : super(key: key);

  @override
  _RequestPart1State createState() => _RequestPart1State();
}

class _RequestPart1State extends State<RequestPart1> {
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
          currentStep: '1',
        ),
        body: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: Stack(
            children: [
              ShapedBackground(),
              Center(
                child: Consumer<RequestModel>(
                  builder: (context, model, child) => ListView(
                    //shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
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
                                  initialValue: model.name,
                                  onEditingCompleted: (value) => model.name = value,
                                  errorText: model.getNameErrorText(),
                                  onChanged: (val) {
                                    if (val == null || val.isEmpty) {
                                      model.setNameErrorText("Please enter a name");
                                    } else {
                                      model.setNameErrorText(null);
                                    }
                                  },
                                ),
                                SizedBox(height: 30),
                                // Redundant column for abstraction
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
                                      onChanged: (val) {
                                        model.setContactMethod(val);
                                        FocusScope.of(context).requestFocus(FocusNode());
                                      },
                                    ),
                                    RadioRow(
                                      label: 'Email',
                                      value: 'email',
                                      groupValue: model.getContactMethod(),
                                      onChanged: (val) {
                                        model.setContactMethod(val);
                                        FocusScope.of(context).requestFocus(FocusNode());
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                AnimatedSwitcher(
                                  duration: Duration(milliseconds: 200),
                                  child: (model.getContactMethod() == "email")
                                      ? CustomTextField(
                                          name: null,
                                          placeholder: "Your email address",
                                          errorText: model.getContactMethodErrorText(),
                                          initialValue: model.email,
                                          keyboardType: TextInputType.emailAddress,
                                          onChanged: (val) {
                                            model.email = val;
                                            if (val == null || val.isEmpty) {
                                              model.setContactMethodErrorText(
                                                  "Please enter an email");
                                            } else {
                                              model.setContactMethodErrorText(null);
                                            }
                                          },
                                        )
                                      : (model.getContactMethod() == "phone")
                                          ? /*InternationalPhoneNumberInput.withCustomBorder(
                                              onInputChanged: (number) {
                                                if (model.getNumberController() != null)
                                                  model.numberFieldValue =
                                                      model.getNumberController().text;
                                                model.phone =
                                                    int.tryParse(number.phoneNumber.substring(1));
                                              },
                                              onInputValidated: (valid) {
                                                if (!valid) model.phone = null;
                                              },
                                              inputBorder: OutlineInputBorder(),
                                              autoValidate: true,
                                              hintText: '',
                                              initialCountry2LetterCode: 'US',
                                              selectorType: PhoneInputSelectorType.DIALOG,
                                              textFieldController: model.getNumberController(),
                                            )*/
                                          CustomTextField(
                                              keyboardType: TextInputType.phone,
                                              name: 'Your phone numbers',
                                              placeholder: 'Please enter your phone number',
                                            )
                                          : Container(),
                                ),
                                SizedBox(height: 30),
                                RaisedButton(
                                  onPressed: () {
                                    bool invalid = false;
                                    if (model.name == null || model.name.isEmpty) {
                                      model.setNameErrorText("Please enter a name");
                                      invalid = true;
                                    }

                                    if (model.getContactMethod() == "phone") {
                                      if (model.phone == null) {
                                        model.setContactMethodErrorText(
                                            "Please enter a phone number");
                                        invalid = true;
                                      }
                                    } else {
                                      if (model.email == null || model.email.isEmpty) {
                                        model.setContactMethodErrorText("Please enter an email");
                                        invalid = true;
                                      }
                                    }

                                    if (!invalid) {
                                      model.saveDefaults();
                                      model.nextPart();
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      SizedBox(width: 70),
                                      Text('Next Step',
                                          style:
                                              styles.introNextStyle.copyWith(color: Colors.white)),
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
