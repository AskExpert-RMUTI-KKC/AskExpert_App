import 'package:askexpertapp/login.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'example/fb.dart';
import 'example/google.dart';
import 'example/store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      //primarySwatch: Colors.black,
    ),
    home: LoginMenu(),
    //home: LoginMenu(),
  ));
}
