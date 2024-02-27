import 'package:flutter/material.dart';

Color bgcolor = Colors.white;
Color primarycolordark = Colors.black;
Color primarycolorlight = Colors.white;
Color textcolordark = Colors.purpleAccent;
Color textcolorlight = Colors.white;
Color splashbg = hexToColor('#F8F4FF');


Color hexToColor(String hexString) {
  hexString = hexString.replaceAll('#', '');
  if (hexString.length == 6) {
    hexString = 'FF' + hexString;
  }
  return Color(int.parse(hexString, radix: 16));
}