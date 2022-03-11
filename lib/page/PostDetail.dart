import 'package:final_project/bean/Good.dart';
import 'package:final_project/util/CommonUtil.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatefulWidget {
  Good good;

  PostDetail({this.good});

  @override
  State<StatefulWidget> createState() {
    return new PostDetailState();
  }
}

class PostDetailState extends State<PostDetail> {
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
        title: Text('PostDetailState'),
        centerTitle: true,
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Column(
      children: [
        Container(
          width: CommonUtil.getScreenWidth(context),
          height: 60,
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Text('Title'),
              Container(
                  width: 300,
                  height: 60,
                  margin: EdgeInsets.only(left: 15),
                  child: Center(
                    child: Text(good.name == null ? "" : good.name),
                  ))
            ],
          ),
        ),
        Container(
          width: CommonUtil.getScreenWidth(context),
          height: 60,
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Text('Price'),
              Container(
                  width: 300,
                  height: 60,
                  margin: EdgeInsets.only(left: 15),
                  child: Center(
                    child: Text(
                      good.amt == null ? "" : good.amt,
                    ),
                  ))
            ],
          ),
        ),
        Container(
          width: CommonUtil.getScreenWidth(context),
          height: 60,
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Text('Desc'),
              Container(
                  width: 300,
                  height: 60,
                  margin: EdgeInsets.only(left: 15),
                  child: Center(
                    child: Text(
                      good.desc == null ? "" : good.desc,
                    ),
                  ))
            ],
          ),
        ),
        Container(
          width: CommonUtil.getScreenWidth(context),
          height: 250,
          child: Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: good.img != null
                      ? NetworkImage(good.img)
                      : AssetImage("images/default_head.png"),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
