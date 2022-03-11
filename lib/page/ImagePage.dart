import 'package:final_project/bean/Good.dart';
import 'package:final_project/util/CommonUtil.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatefulWidget {
  Good good;

  ImagePage({this.good});

  @override
  State<StatefulWidget> createState() {
    return new ImagePageState();
  }
}

class ImagePageState extends State<ImagePage> {
  Good good;

  @override
  void initState() {
    super.initState();
    good = widget.good;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
      ),
      body: Container(
        width: CommonUtil.getScreenWidth(context),
        height: CommonUtil.getScreenHeight(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: good.img != null
                ? NetworkImage(good.img)
                : AssetImage("images/default_head.png"),
          ),
        ),
      ),
    );
  }
}
