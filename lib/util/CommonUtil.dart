import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'SharedPreferencesUtil.dart';
import 'ToastUtil.dart';
import 'package:intl/intl.dart' show DateFormat;

class CommonUtil {
  /// 函数防抖 过滤重复点击
  ///
  /// [func]: 要执行的方法
  /// [delay]: 要迟延的时长
  static Function debounce(
    Function func, [
    Duration delay = const Duration(milliseconds: 1000),
  ]) {
    Timer timer;
    Function target = () {
      if (timer?.isActive ?? false) {
        timer?.cancel();
      }
      timer = Timer(delay, () {
        func?.call();
      });
    };
    return target;
  }

  /// 函数节流
  ///
  /// [func]: 要执行的方法
  static Function throttle(
    Future Function() func,
  ) {
    if (func == null) {
      return func;
    }
    bool enable = true;
    Function target = () {
      if (enable == true) {
        enable = false;
        func().then((_) {
          enable = true;
        });
      }
    };
    return target;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isChinaPhoneLegal(String str) {
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }

  static pushPage(BuildContext context, Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
  }

  static String format(int time, {String format = "yyyy-MM-dd"}) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat(format).format(date);
  }

  static String format2(DateTime date, {String format = "yyyy年MM月dd日 HH:mm"}) {
    return DateFormat(format).format(date);
  }

  static void push(BuildContext context, Widget widget) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => widget));
  }

  static bool hasLogin() {
    return SharedPreferencesUtil.getString('phone') != null &&
        SharedPreferencesUtil.getString('phone').isNotEmpty;
  }

  static Widget getHeight_Margin(double h) {
    return Container(
      width: 1,
      height: h,
    );
  }

  static Widget getWidth_Margin(double w) {
    return Container(
      width: w,
      height: 1,
    );
  }

  static String getFileName(String name) {
    List strs = name.split('/');
    return strs[strs.length - 1];
  }
}
