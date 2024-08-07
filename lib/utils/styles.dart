import 'package:flutter/material.dart';

class Styles {
  // Colors

  static const backgroundColor = Color(0xFFEC1EC2);
  static const mainAppColor = Colors.black;

  static const textStyleTittle = TextStyle(
    color: Colors.white,
    fontSize: 24.0,
    fontWeight: FontWeight.w800,
  );

  static const textStyleTittle2 = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    fontWeight: FontWeight.w800,
  );
  static const textStyleDropdownButton = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const textstyleBarChartBottom = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const backgroundGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Styles.mainAppColor,
        Styles.mainAppColor,
        Styles.backgroundColor,
        Styles.backgroundColor,
      ],
    ),
  );
}
