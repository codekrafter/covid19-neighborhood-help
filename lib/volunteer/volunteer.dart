// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:neighborhood_help/styles.dart' as styles;
// import 'package:google_maps_webservice/places.dart';

// import 'intro.dart';
// import 'part1.dart';
// import 'part2.dart';
// import 'part3.dart';

// class VolunteerModel extends ChangeNotifier {
//   Widget _currentPart = _partsMap[0];
//   int _currentPartIndex = 0;

//   static const List<Widget> _partsMap = [
//     RequestIntro(),
//     RequestPart1(),
//     RequestPart2(),
//     RequestPart3(),
//   ];

//   Widget getCurrentPart() => _currentPart;

//   void _setCurrentPart(Widget newPart) {
//     _currentPart = newPart;

//     notifyListeners();
//   }

//   void nextPart() {
//     _currentPartIndex++;

//     //_setCurrentPart(_partsMap[_currentPartIndex]);
//   }

//   void previousPart() {
//     _currentPartIndex--;

//     _setCurrentPart(_partsMap[_currentPartIndex]);
//   }

//   String getCurrentTitleText() {
//     switch(_currentPartIndex) {}
//   }
// }

// class VolunteerPage extends StatefulWidget {
//   VolunteerPage({Key key}) : super(key: key);

//   @override
//   _VolunteerPageState createState() => _VolunteerPageState();
// }

// class _VolunteerPageState extends State<VolunteerPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).requestFocus(FocusNode()), // On tap close any keyboards
//         child: ChangeNotifierProvider<VolunteerModel>(
//           create: (context) => VolunteerModel(),
//           child: Builder(
//             builder: (context) => AnimatedSwitcher(
//               duration: Duration(milliseconds: 400),
//               /*transitionBuilder: (child, animation) => SlideTransition(
//                 position: animation.drive(
//                   Tween(begin: Offset(1, 0), end: Offset.zero),
//                 ),
//                 child: child,
//               ),*/
//               child: Provider.of<VolunteerModel>(context).getCurrentPart(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class RequestStepAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const RequestStepAppBar({@required this.currentStep, this.totalSteps = '3', Key key})
//       : assert(currentStep != null),
//         assert(totalSteps != null),
//         super(key: key);

//   final String currentStep;
//   final String totalSteps;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         color: styles.requestBlue,
//         child: Consumer<VolunteerModel>(
//           builder: (context, model, child) => Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 2),
//             child: Row(children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.arrow_back,
//                   color: Colors.white,
//                   size: 23,
//                 ),
//                 onPressed: () => model.previousPart(),
//               ),
//               Text(
//                 'Step $currentStep of $totalSteps',
//                 style: styles.stepHeaderStyle,
//               )
//             ]),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(100);
// }
