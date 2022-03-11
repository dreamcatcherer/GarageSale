import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      // 消息框弹出的位置
      timeInSecForIosWeb: 1,
      // 消息框持续的时间（目前的版本只有ios有效）
    );
  }
}
