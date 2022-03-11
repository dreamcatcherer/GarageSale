import 'dart:async';
import 'dart:io';

import 'package:final_project/bean/Good.dart';
import 'package:final_project/util/CommonUtil.dart';
import 'package:final_project/util/ToastUtil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;

class NewPost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NewPostState();
  }
}

class NewPostState extends State<NewPost> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  final picker = ImagePicker();
  String imagePath = null;
  DatabaseReference root_database_ref =
      FirebaseDatabase.instance.reference().child('goods');
  DatabaseReference childRef;

  firebase_storage.Reference imgRef =
      firebase_storage.FirebaseStorage.instance.ref().child('imgs');

  @override
  void initState() {
    super.initState();
    childRef = root_database_ref.root();
  }

  @override
  void dispose() {
    super.dispose();
  }

  post() {
    if (titleController.text.isEmpty) {
      ToastUtil.showToast('请输入标题');
      return;
    }
    if (priceController.text.isEmpty) {
      ToastUtil.showToast('请输入价格');
      return;
    }
    if (descController.text.isEmpty) {
      ToastUtil.showToast('请输入描述');
      return;
    }
    if (imagePath == null) {
      ToastUtil.showToast('请输入选择图片');
      return;
    }

    _uploadProfilePicture();
  }

  Future<Null> _uploadProfilePicture() async {
    print('=== imagePath:${imagePath}');
    showLoadingDialog();
    String imageName = CommonUtil.getFileName(imagePath);

    imgRef = firebase_storage.FirebaseStorage.instance.ref().child(imageName);
    firebase_storage.UploadTask uploadTask;

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': imagePath});

    uploadTask = imgRef.putFile(io.File(imagePath), metadata);
    uploadTask.then((v) {
      v.ref.getDownloadURL().then((value) {
        print('=== getDownloadURL:${value}');
        Navigator.of(context).pop();
        Good good = Good(
            name: titleController.text,
            amt: priceController.text,
            desc: descController.text,
            img: value);
        childRef.child(childRef.push().key).set(good.toJson());
      });
    });
  }

  showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('正在上传中，请稍后'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          // actions: <Widget>[
          //   FlatButton(
          //     child: Text('确认'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  Future takePhoto(int choose) async {
    PickedFile pickedFile; // 相机
    if (choose == 1) {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      }); // 选择的图片或照片的路径
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NewPost'),
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
                  child: TextField(
                    controller: titleController,
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
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
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
                  child: TextField(
                    controller: descController,
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
              decoration: getBox(),
            ),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => takePhoto(2),
              child: Container(
                width: CommonUtil.getScreenWidth(context) / 2,
                height: 50,
                child: Container(
                  width: 100,
                  height: 50,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Center(
                    child: Text('相册'),
                  ),
                ),
              ),
            ),
            GestureDetector(
                onTap: () => takePhoto(1),
                child: Container(
                  width: CommonUtil.getScreenWidth(context) / 2,
                  height: 50,
                  child: Container(
                    width: 100,
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Center(
                      child: Text('拍照'),
                    ),
                  ),
                ))
          ],
        ),
        Container(
          width: 1,
          height: 50,
        ),
        GestureDetector(
            onTap: () => post(),
            child: Container(
              width: CommonUtil.getScreenWidth(context),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Center(
                child: Text('POST'),
              ),
            )),
      ],
    );
  }

  getBox() {
    if (imagePath == null) {
      return BoxDecoration();
    }
    return BoxDecoration(
      image:
          DecorationImage(fit: BoxFit.cover, image: FileImage(File(imagePath))),
    );
  }
}
