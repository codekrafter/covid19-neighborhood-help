import 'package:flutter/material.dart';

// All styles are getters to support hot reload

TextStyle get homeOptionStyle => TextStyle(
  color: requestBlue,
  fontWeight: FontWeight.w700,
  fontSize: 22
);

Color get whiteBackgroundColor => Color(0xFFECEEF3);

Color get requestBlue => Color(0xFF394BBB);

Color get darkTextColor => Color(0xFF37383C);

Color get backgroundWhite => Color(0xFFECEEF3);

Color get inputBorderColor => Color(0xFFDDDDDD);

Color get urgentColor => Color(0xFFFF9F33);

TextStyle get introTextStyle => TextStyle(
  color: darkTextColor,
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

TextStyle get textFieldNameStyle => TextStyle(
  color: darkTextColor,
  fontWeight: FontWeight.w800,
  fontSize: 15
);

TextStyle get requiredMarkStyle => TextStyle(
  color: Colors.red,
  fontWeight: FontWeight.w800,
  fontSize: 15
);

TextStyle get postTitleStyle => TextStyle(
  color: darkTextColor,
  fontWeight: FontWeight.w800,
  fontSize: 15
);

TextStyle get postBodyStyle => TextStyle(
  color: darkTextColor,
  fontSize: 15
);

TextStyle get contactFeatureStyle => TextStyle(
  color: darkTextColor,
  fontWeight: FontWeight.w800,
  fontSize: 16
);