import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'page/BrowsePost.dart';
import 'util/SharedPreferencesUtil.dart';

void main() {
  initFirebase();
  SharedPreferencesUtil.getInstance();
  runApp(MyApp());
}

initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  FirebaseDatabase.instance.setPersistenceEnabled(true);

  DatabaseReference root_database_ref =
      FirebaseDatabase.instance.reference().child('goods');
  DatabaseReference childRef = root_database_ref.root();
  childRef.set('');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BrowsePost(),
    );
  }
}
