import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color textColor = Colors.black;
  static const Color buttonColorLight = Colors.black54;
  static const Color themeColor = Color(0XFF290FBA);
  static const Color textButtonColor = Color(0XFF290FBA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);
  static const Color blue = Color(0XFF9ED1FB);
  static const Color red = Color(0xFFF11717);
  static const Color grey = Color(0xffd9d9d9);
  static const Color darkBlue = Color(0XFF4725A6);
  static const Color buttonBlue = Color(0xff2c3af1);
  static const Color viewBackground = Color(0XFFEEF0F3);

  static const TextStyle textStyleHeading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    height: 1.5,
  );

  static const TextStyle textStyleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle normal = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static const TextStyle menuTextStyle = TextStyle(
    color: AppTheme.darkBlue,
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: AppTheme.darkBlue,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const double footerHeight = 0.16;
}
