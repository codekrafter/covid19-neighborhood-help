// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:neighborhood_help/styles.dart' as styles;
// import 'request.dart';

// class RequestIntro extends StatelessWidget {
//   const RequestIntro({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle(
//           statusBarColor: styles.backgroundWhite,
//           statusBarBrightness: Brightness.light,
//           statusBarIconBrightness: Brightness.dark),
//       child: Scaffold(
//         backgroundColor: styles.backgroundWhite,
//         appBar: IntroAppBar(),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             //crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Padding(
//               //   padding: const EdgeInsets.symmetric(horizontal: 2),
//               //   child: Row(children: [
//               //     IconButton(
//               //       icon: Icon(
//               //         Icons.arrow_back,
//               //         color: styles.introGrey,
//               //         size: 23,
//               //       ),
//               //       onPressed: () => Navigator.pop(context),
//               //     ),
//               //     Text(
//               //       'How it works',
//               //       style: styles.stepHeaderStyle.copyWith(color: styles.introGrey),
//               //     )
//               //   ]),
//               // ),
//               SizedBox(height: 75),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Image.asset('assets/how_it_works_placeholder.png'),
//                     SizedBox(height: 30),
//                     Text('Send a request',
//                         style: styles.titleStyle.copyWith(color: styles.darkTextColor)),
//                     SizedBox(height: 25),
//                     Text(
//                       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ultrices convallis nulla, ut ullamcorper erat euismod quis.',
//                       textAlign: TextAlign.center,
//                       style: styles.introTextStyle,
//                     ),
//                     SizedBox(height: 45),
//                     /*GestureDetector(
//                         onTap: () {},
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text('Skip', style: styles.introNextStyle),
//                             SizedBox(width: 10),
//                             Icon(
//                               Icons.arrow_forward,
//                               size: 25,
//                               color: styles.requestBlue,
//                             )
//                           ],
//                         ),
//                       ),*/
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                       child: Consumer<RequestModel>(
//                         builder: (context, model, child) => OutlineButton(
//                           onPressed: () => model.nextPart(),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             mainAxisSize: MainAxisSize.max,
//                             children: <Widget>[
//                               SizedBox(width: 90),
//                               Text('Skip', style: styles.introNextStyle),
//                               SizedBox(width: 90),
//                               Icon(
//                                 Icons.arrow_forward,
//                                 size: 25,
//                                 color: styles.requestBlue,
//                               )
//                             ],
//                           ),
//                           color: styles.requestBlue,
//                           borderSide: BorderSide(
//                             color: styles.requestBlue,
//                             style: BorderStyle.solid,
//                             width: 2,
//                           ),
//                           padding: const EdgeInsets.all(16.0),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 30)
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class IntroAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const IntroAppBar({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 2),
//         child: Row(children: [
//           IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: styles.darkTextColor,
//               size: 23,
//             ),
//             onPressed: () => Navigator.pop(context),
//           ),
//           Text(
//             'How it works',
//             style: styles.stepHeaderStyle.copyWith(color: styles.darkTextColor),
//           )
//         ]),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(100);
// }
