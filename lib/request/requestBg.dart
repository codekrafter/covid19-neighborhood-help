import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vm;

import 'package:neighborhood_help/styles.dart' as styles;

class RequestBackground extends StatelessWidget {
  RequestBackground({Key key}) : super(key: key);

  double storedWidth;
  double storedHeight;

  @override
  Widget build(BuildContext context) {

    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Center(
        child: CustomPaint(
          child: Container(),
          painter: RequestBackgroundPainter(context),
        ),
      ),
    );
  }
}

class RequestBackgroundPainter extends CustomPainter {
  RequestBackgroundPainter(this.context);

  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    /*if (storedWidth == null || storedHeight == null) {
      storedWidth = MediaQuery.of(context).size.width;
      storedHeight = MediaQuery.of(context).size.height;
    }*/

    final paint = Paint()..color = styles.requestBlue;
    canvas.drawArc(
        /*Rect.fromCenter(
            center: size.center(Offset.fromDirection(vm.radians(270), size.height * .20)),
            height: 175,
            width: size.width * 1.2),*/
          Rect.fromPoints(size.topLeft(Offset(-50, 0)), size.topRight(Offset(50, 300))),
        vm.radians(0),
        vm.radians(180),
        true,
        paint);

    canvas.drawRect(
        Rect.fromPoints(size.topLeft(Offset.zero), size.centerRight(Offset(0, size.height * -0.19))), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
