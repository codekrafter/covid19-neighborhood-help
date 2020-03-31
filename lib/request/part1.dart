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
      child: SafeArea(
        child: Scaffold(
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
                      SizedBox(
                        height: 10,
                      ),
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
                                  name: 'Your location',
                                  placeholder: 'City, postal code or address',
                                  isRequired: true,
                                ),
                                SizedBox(height: 30),
                                CustomTextField(
                                  name: 'Message Request',
                                  placeholder: '"I need help with my groceries"',
                                  isRequired: false,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                ),
                                SizedBox(height: 30),
                                Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: const Text('Lafayette'),
                                      leading: Radio(
                                        value: 'value1',
                                        groupValue: 'value1',
                                        onChanged: (val) {},
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Thomas Jefferson'),
                                      leading: Radio(
                                          value: 'value',
                                          groupValue: 'value1',
                                          onChanged: (val) {}),
                                    ),
                                  ],
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
      ),
    );
  }
}
