import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:neighborhood_help/styles.dart' as styles;

class IntroSection extends StatelessWidget {
  final String titleText;
  final String bodyText;
  final bool lastIntro;
  final Function() onButtonTapped;
  final Function() onBackButtonTapped;
  const IntroSection(
      {@required this.titleText,
      @required this.bodyText,
      this.lastIntro = false,
      this.onButtonTapped,
      this.onBackButtonTapped,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: styles.backgroundWhite,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: styles.backgroundWhite,
        appBar: IntroAppBar(
          onButtonTapped: onBackButtonTapped,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 75),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/how_it_works_placeholder.png'),
                    SizedBox(height: 30),
                    Text(titleText, style: styles.titleStyle.copyWith(color: styles.darkTextColor)),
                    SizedBox(height: 25),
                    Text(
                      bodyText,
                      textAlign: TextAlign.center,
                      style: styles.introTextStyle,
                    ),
                    SizedBox(height: 45),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: OutlineButton(
                        onPressed: () => (onButtonTapped != null) ? onButtonTapped() : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            SizedBox(width: 90),
                            Text((lastIntro) ? 'Start' : 'Next', style: styles.introNextStyle),
                            SizedBox(width: 90),
                            Icon(
                              Icons.arrow_forward,
                              size: 25,
                              color: styles.requestBlue,
                            )
                          ],
                        ),
                        color: styles.requestBlue,
                        borderSide: BorderSide(
                          color: styles.requestBlue,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 30)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IntroAppBar extends StatelessWidget implements PreferredSizeWidget {
  const IntroAppBar({this.onButtonTapped, Key key}) : super(key: key);

  final Function onButtonTapped;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Row(children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: styles.darkTextColor,
              size: 23,
            ),
            onPressed: () => (onButtonTapped != null) ? onButtonTapped() : Navigator.pop(context),
          ),
          Text(
            'How it works',
            style: styles.stepHeaderStyle.copyWith(color: styles.darkTextColor),
          )
        ]),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}
