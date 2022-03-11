import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:final_project/bean/User.dart';
import 'package:final_project/util/ToastUtil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  TextEditingController phoneController = new TextEditingController();
  TextEditingController pwController = new TextEditingController();
  TextEditingController pw2Controller = new TextEditingController();
  StreamSubscription<Event> childSubscription;
  DatabaseReference root_database_ref =
      FirebaseDatabase.instance.reference().child('users');
  DatabaseReference childRef;

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    childRef = root_database_ref.root();

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
      });
    }
    return result;
  }

  @override
  void dispose() {
    childSubscription?.cancel();
    super.dispose();
  }

  doRegister() {
    if (phoneController.text.isEmpty) {
      ToastUtil.showToast('Please Input Account');
      return;
    }

    if (pwController.text.isEmpty) {
      ToastUtil.showToast('Please Input Password');
      return;
    }
    if (pw2Controller.text.isEmpty) {
      ToastUtil.showToast('Please Input Password Again');
      return;
    }
    if (pwController.text != pw2Controller.text) {
      ToastUtil.showToast('The Two Password dont Match');
      setState(() {
        pwController.text = '';
        pw2Controller.text = '';
      });
      return;
    }
    childSubscription = childRef.onValue.listen((event) {
      if (event?.snapshot?.value.toString() != 'test') {
        print('=== register: ${event?.snapshot?.value}');
        ToastUtil.showToast('Register Success');
        Navigator.pop(context);
      }
    });
    User user =
        User(account: phoneController.text, password: pwController.text);
    Map map = Map();
    map['1'] = user.toJson();
    childRef.set('test');
    childRef.child(childRef.push().key).set(user.toJson());
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
            SizedBox(height: 70.w),
            getTextField(0, 'Please Input Account'),
            SizedBox(height: 30.w),
            getTextField(1, 'Please Input Password'),
            SizedBox(height: 30.w),
            getTextField(2, 'Please Input Password Again'),
            SizedBox(height: 100.w),
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
                    doRegister();
                  },
                  shape: StadiumBorder(
                      side: BorderSide(
                    width: 1.w,
                    color: Colors.blue,
                  )),
                  child: Text(
                    'Register',
                    style: TextStyle(
                        fontSize:
                            ScreenUtil().setSp(36, allowFontScalingSelf: false),
                        color: Colors.white),
                  ),
                )),
          ],
        ));
  }

  Widget getTextField(var type, var title) {
    String prefixIconPath;
    TextEditingController controller;
    TextInputType textType;
    switch (type) {
      case 0: //表示手机号
        prefixIconPath = 'images/login_phone.png';
        controller = phoneController;
        textType = TextInputType.number;
        break;
      case 1: //密码
        prefixIconPath = 'images/login_invite.png';
        controller = pwController;
        textType = TextInputType.visiblePassword;
        break;
      case 2: //密码
        prefixIconPath = 'images/login_invite.png';
        controller = pw2Controller;
        textType = TextInputType.visiblePassword;
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
            obscureText: type == 1 || type == 2,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(type == 0 ? 11 : 6) //限制长度
            ],
            cursorWidth: 1.w,
            cursorColor: Colors.blue,
            keyboardType: textType,
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
