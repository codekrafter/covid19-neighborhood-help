import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'styles.dart' as styles;
import 'langSelect.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage('assets/how_it_works_placeholder.png'), context);
  }*/

  @override
  Widget build(BuildContext context) {
    checkUserStatus();
    precacheImage(AssetImage('assets/how_it_works_placeholder.png'), context);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SvgPicture.asset('assets/home/background.svg', fit: BoxFit.fill),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Logo',
                    style: styles.stepHeaderStyle,
                  ),
                  LanguageSelect()
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Connecting those affected by COVID-19', style: styles.subtitleStyle),
                Text(
                  'What would you like to do?',
                  style: styles.titleStyle,
                ),
                SizedBox(height: 30),
                HomeSelection(
                  message: 'I need help',
                  image: SvgPicture.asset('assets/home/requester.svg'),
                  imagePos: EdgeInsets.fromLTRB(14.9, null, null, 8),
                  onTap: () => Navigator.of(context).pushNamed('/request'),
                ),
                SizedBox(
                  height: 15,
                ),
                HomeSelection(
                  message: 'I want to help',
                  image: SvgPicture.asset('assets/home/volunteer.svg'),
                  imagePos: EdgeInsets.fromLTRB(14.9, null, null, 17),
                  onTap: () => Navigator.of(context).pushNamed('/volunteer'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> checkUserStatus() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    if (currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    } else {
      try {
        await currentUser.getIdToken(refresh: true);
      } on PlatformException catch (e) {
        if (e.code == "ERROR_USER_NOT_FOUND") {
          await FirebaseAuth.instance.signOut();
          checkUserStatus();
        } else {
          throw e;
        }
      }
    }
  }
}

class HomeSelection extends StatelessWidget {
  const HomeSelection(
      {@required this.message, @required this.image, @required this.imagePos, this.onTap, Key key})
      : assert(message != null),
        assert(image != null),
        assert(imagePos != null),
        super(key: key);

  final String message;
  final SvgPicture image;
  final Function onTap;
  final EdgeInsets imagePos;

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              //enableFeedback: true,
              //excludeFromSemantics: true,
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 95, height: 75),
                  Text(
                    message,
                    style: styles.homeOptionStyle,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: styles.requestBlue,
                    size: 30,
                  ),
                  SizedBox(width: 30)
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: imagePos.left,
          top: imagePos.top,
          right: imagePos.right,
          bottom: imagePos.bottom,
          child: image,
        ),
      ],
    );
  }
}
