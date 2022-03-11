import 'dart:async';
import 'dart:io';

import 'package:final_project/bean/User.dart';
import 'package:final_project/util/CommonUtil.dart';
import 'package:final_project/util/SharedPreferencesUtil.dart';
import 'package:final_project/util/ToastUtil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Config.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController userPhone = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();

  StreamSubscription<Event> childSubscription;
  DatabaseReference root_database_ref =
      FirebaseDatabase.instance.reference().child('users');
  DatabaseReference childRef;
  List<User> users = List();

  @override
  void initState() {
    super.initState();
    childRef = root_database_ref.root();
    childSubscription = childRef.onValue.listen((event) {
      if (event?.snapshot?.value != null) {
        print('=== login : ${event?.snapshot?.value}');
        users.clear();
        Map map;
        try {
          if (event?.snapshot?.value.toString() != 'test') {
            map = event?.snapshot?.value;
          }
        } catch (e) {}
        if (map != null) {
          map.forEach((key, value) {
            print('=== key:$key value:$value');
            User user =
                User(account: value['account'], password: value['password']);
            users.add(user);
          });
        }
      }
    });

    query();
  }

  Future<void> query() async {
    print('=== query');
    var result = (await childRef.once()).value;
    Map map;
    try {
      if (result.toString() != 'test') {
        map = result;
      }
    } catch (e) {}
    if (map != null) {
      map.forEach((key, value) {
        print('=== key:$key value:$value');
        User user =
            User(account: value['account'], password: value['password']);
        users.add(user);
      });
    }
    return result;
  }

  @override
  void dispose() {
    childSubscription.cancel();
    super.dispose();
  }

  login() {
    //CommonUtil.push(context, MyTabNavigator());
    if (userPhone.text.isEmpty) {
      ToastUtil.showToast('Please Input Account');
      return;
    }
    if (pwController.text.isEmpty) {
      ToastUtil.showToast('Please Input Password');
      return;
    }
    for (User user in users) {
      if (user.account == userPhone.text &&
          user.password == pwController.text) {
        ToastUtil.showToast('Login Success');
        SharedPreferencesUtil.saveString('phone', userPhone.text);
        Config.phone = userPhone.text;
        //CommonUtil.push(context, MyTabNavigator());
        return;
      }
    }
    ToastUtil.showToast('Account or Password Error');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark, //修改状态栏文字颜色的
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: new Scaffold(
            backgroundColor: Colors.white,
            body: getBox(1),
            resizeToAvoidBottomInset: false,
          ),
        ),
      ),
    );
  }

  Widget getBox(double scale) {
    return Transform.scale(
        scale: scale,
        child: ListView(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  width: ScreenUtil().screenWidthPx,
                  height: 400.h,
                ),
                Positioned(
                  top: 160.h,
                  child: Image.asset('images/ic_launcher.png',
                      width: 160.h, height: 160.h),
                ),
                Positioned(
                  bottom: 0.w,
                  child: Text(
                    'Final Project',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          ScreenUtil().setSp(48, allowFontScalingSelf: false),
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80.w),
            getTextField(0, 'Please Input Account'),
            SizedBox(height: 40.w),
            getTextField(1, 'Please Input Password'),
            SizedBox(height: 80.w),
            Container(
                margin: EdgeInsets.only(left: 55.w, right: 55.w),
                width: ScreenUtil().screenWidthPx,
                height: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0), //圆角
                  gradient: LinearGradient(colors: <Color>[
                    //背景渐变
                    Color(0xFF90CAF9),
                    Color(0xFF42A5F5),
                  ]),
                ),
                child: FlatButton(
                  color: Colors.transparent,
                  onPressed: () {
                    login();
                  },
                  shape: StadiumBorder(
                      side: BorderSide(
                    width: 1.w,
                    color: Colors.blue,
                  )),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize:
                            ScreenUtil().setSp(36, allowFontScalingSelf: false),
                        color: Colors.white),
                  ),
                )),
            SizedBox(height: 30.w),
            Container(
              margin: EdgeInsets.only(left: 65.w, right: 65.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(''),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return new RegisterPage();
                      }));
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget getTextField(var type, var title) {
    String prefixIconPath;
    TextEditingController controller;
    switch (type) {
      case 0: //表示手机号
        prefixIconPath = 'images/login_phone.png';
        controller = userPhone;
        break;
      case 1: //密码
        prefixIconPath = 'images/login_invite.png';
        controller = pwController;
        break;
    }
    return Container(
      margin: EdgeInsets.only(left: 55.w, right: 55.w),
      alignment: Alignment.center,
      height: 88.w,
      decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(color: Colors.blue, width: 1.h),
          borderRadius: new BorderRadius.circular(44.0)),
      child: Row(
        children: [
          Expanded(
              child: new TextField(
            controller: controller,
            obscureText: type == 1,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(type == 0 ? 11 : 6) //限制长度
            ],
            cursorWidth: 1.w,
            cursorColor: Colors.blue,
            keyboardType:
                type == 0 ? TextInputType.phone : TextInputType.visiblePassword,
            style: TextStyle(
                letterSpacing: 1.w,
                color: Colors.black,
                fontSize: ScreenUtil().setSp(32, allowFontScalingSelf: false)),
            decoration: InputDecoration(
              icon: Padding(
                padding: EdgeInsets.only(left: 30.w),
                child: Image.asset(
                  prefixIconPath,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              //不需要输入框下划线
              border: InputBorder.none,
              hintText: title,
              hintStyle: TextStyle(
                  letterSpacing: 1.w, //字符间距
                  color: Color(0xFFBDBDBD),
                  fontSize:
                      ScreenUtil().setSp(28, allowFontScalingSelf: false)),
            ),
          )),
        ],
      ),
    );
  }
}
