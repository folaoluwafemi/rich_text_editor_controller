import 'package:flutter/material.dart';

abstract class UtilFunctions {
  static Color colorFromMap(dynamic map) {
    return Color(int.parse(map['color'].toString()));
  }
}
