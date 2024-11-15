import 'package:flutter/material.dart';

class Constants {
  //COLORS
  static Color get backgrondColor => const Color.fromARGB(255, 255, 255, 255);
  static Color get primaryColor => const Color(0xFF001B48);
  static Color get secondColor => const Color(0xFF004581);
  static Color get letterColor => const Color(0xFF018ABD);
  static Color get cardColor => const Color.fromARGB(143, 17, 170, 226);
  static Color get grayColor => const Color.fromARGB(255, 218, 218, 218);

  //SIZE
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getFontSize(BuildContext context) {
    return getScreenHeight(context) * 0.02;
  }
}
const Color cardColor = Color.fromARGB(255, 155, 155, 155);
const Color backgroundColor = Color.fromARGB(255, 228, 228, 228);
const Color orangeColor = Color.fromARGB(255, 233, 133, 52);
const Color backgroundColorLight = Color(0xFFF2F6FF);
const Color backgroundColorDark = Color(0xFF25254B);
const Color shadowColorLight = Color(0xFF4A5367);
const Color shadowColorDark = Colors.black;



