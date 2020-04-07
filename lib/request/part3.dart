import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neighborhood_help/styles.dart';

import 'package:neighborhood_help/styles.dart' as styles;
import 'package:provider/provider.dart';
import 'request.dart';

import 'package:neighborhood_help/shapedBg.dart';

class RequestPart3 extends StatelessWidget {
  const RequestPart3({Key key}) : super(key: key);

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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                /*Text(
                  'Step $currentStep of $totalSteps',
                  style: styles.stepHeaderStyle,
                )*/
              ]),
            ),
          ),
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
                            'Request sent, ${model.name}',
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
                              Text(
                                'What happens next?',
                                style: styles.postTitleStyle,
                              ),
                              SizedBox(height: 7.5),
                              Text(
                                'Your request is live and will be visible to helpers in your area. When someone can help, they will reach out to you on your ${(model.getContactMethod() == 'phone') ? 'phone number' : model.getContactMethod()}:',
                                style: styles.postBodyStyle,
                              ),
                              SizedBox(height: 15),
                              Material(
                                color: styles.inputBorderColor,
                                elevation: 0,
                                borderRadius: BorderRadius.circular(3),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    model.getContactDetails(),
                                    style: styles.contactFeatureStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'What if no one helps me?',
                                style: styles.postTitleStyle,
                              ),
                              SizedBox(height: 7.5),
                              Text(
                                "If we can't find anyone to help within three days, we'll ${(model.getContactMethod() == 'phone') ? 'text/call' : model.getContactMethod()} you with a link to resubmit your request.",
                                style: styles.postBodyStyle,
                              ),
                              SizedBox(
                                height: 230,
                              )
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
