import 'dart:async';

import 'package:final_project/bean/Good.dart';
import 'package:final_project/page/PostDetail.dart';
import 'package:final_project/util/CommonUtil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'ImagePage.dart';
import 'NewPost.dart';

class BrowsePost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BrowsePostState();
  }
}

class BrowsePostState extends State<BrowsePost> {
  DatabaseReference root_database_ref =
      FirebaseDatabase.instance.reference().child('goods');
  DatabaseReference childRef;
  StreamSubscription<Event> childSubscription;
  List<Good> list = List();
  var _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    childRef = root_database_ref.root();
    childSubscription = childRef.onValue.listen((event) {
      print('=== add: ${event.snapshot.value}');
      if (event.snapshot.value != null && event.snapshot.value != '') {
        list.clear();
        Map map = event.snapshot.value;
        map.forEach((key, value) {
          print('=== value: ${value}');
          Good good = Good(
              name: value['name'],
              amt: value['amt'],
              desc: value['desc'],
              img: value['img']);
          list.add(good);
        });
        setState(() {});
        showInSnackBar('新增成功');
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    childSubscription?.cancel();
    super.dispose();
  }

  void showInSnackBar(String value) {
    _scaffoldkey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('HyperGarageSale'),
        centerTitle: true,
        actions: [
          new FlatButton(
            child: IconButton(color: Colors.white, icon: Icon(Icons.add)),
            onPressed: () {
              CommonUtil.push(context, NewPost());
            },
          ),
        ],
      ),
      body: list.length > 0 ? buildBody() : buildNullView(),
    );
  }

  buildNullView() {
    return Container();
  }

  buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [for (Good good in list) buildItem(good)],
      ),
    );
  }

  buildItem(Good good) {
    return GestureDetector(
      onTap: () {
        CommonUtil.push(
            context,
            ImagePage(
              good: good,
            ));
      },
      child: Container(
        width: CommonUtil.getScreenWidth(context),
        height: 60,
        margin: EdgeInsets.all(20),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image(
                width: 80,
                height: 60,
                image: good.img == null
                    ? AssetImage('images/default_head.png')
                    : NetworkImage(good.img),
              ),
            ),
            Positioned(
                left: 100,
                top: 10,
                child: GestureDetector(
                    onTap: () {
                      CommonUtil.push(
                          context,
                          PostDetail(
                            good: good,
                          ));
                    },
                    child: Container(
                      height: 30,
                      width: 200,
                      color: Colors.transparent,
                      child: Text(good.name),
                    ))),
            Positioned(
                left: 100,
                top: 35,
                child: GestureDetector(
                    onTap: () {
                      CommonUtil.push(
                          context,
                          PostDetail(
                            good: good,
                          ));
                    },
                    child: Container(
                      height: 30,
                      width: 200,
                      color: Colors.transparent,
                      child: Text(good.amt),
                    ))),
          ],
        ),
      ),
    );
  }
}
