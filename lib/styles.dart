import 'package:flutter/material.dart';

// All styles are getters to support hot reload

TextStyle get homeOptionStyle => TextStyle(
  color: requestBlue,
  fontWeight: FontWeight.w700,
  fontSize: 22
);

Color get requestBlue => Colors.indigo[600];

Color get introGrey => Colors.grey[800];

TextStyle get introTextStyle => TextStyle(
  color: introGrey,
  fontSize: 18.5
);

TextStyle get introNextStyle => TextStyle(
  color: requestBlue,
  fontWeight: FontWeight.w700,
  fontSize: 20
);

TextStyle get subtitleStyle => TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w300,
  fontSize: 17,
);
TextStyle get stepHeaderStyle => TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 16,
);
TextStyle get titleStyle => TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w900,
  fontSize: 25,
);