import 'dart:convert';

import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/TopicDataModel.dart';
import 'package:askexpertapp/page/topic/CommentPage.dart';
import 'package:askexpertapp/page/register_login/Login.dart';
import 'package:askexpertapp/page/register_login/Register.dart';
import 'package:askexpertapp/utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome",
          style: TextStyle(
            color: Color(ConfigApp.textColor),
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [],
        elevation: 0,
        centerTitle: false,
        backgroundColor: const Color(ConfigApp.appbarBg),
      ),
      backgroundColor: const Color(ConfigApp.appbarBg),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Placeholder(),
                    Placeholder(),
                    Placeholder(),
                  ],
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(LoginPage());
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(ConfigApp.buttonSecondary),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    primary: Color(ConfigApp.buttonPrimary),
                    elevation: 5,
                    shape: shape,
                    //side: BorderSide(width: 1,color: Color(Config.textColor),)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(RegisterPage());
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(ConfigApp.buttonPrimary),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    primary: Color(ConfigApp.buttonSecondary),
                    elevation: 5,
                    shape: shape,
                    //side: BorderSide(width: 1,color: Color(Config.textColor),)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
