import 'package:flutter/material.dart';
import 'dart:ui' show Color;

import 'bean/PersonInfoBean.dart';

class Config {
  static String phone = '';
  static String name = '';
  static Color themeColor = Colors.blue;

  static List ThemeColors = [
    Colors.blue,
    Colors.yellow,
    Colors.pink,
    Colors.red,
    Colors.green,
    Colors.indigo,
    Colors.brown,
    Colors.teal,
  ];

  static List<PersonInfoBean> persons = List();
}
