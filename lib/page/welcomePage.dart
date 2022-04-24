import 'dart:convert';

import 'package:askexpertapp/config/config.dart';
import 'package:askexpertapp/dataModel/topicDataModel.dart';
import 'package:askexpertapp/page/commentPage.dart';
import 'package:askexpertapp/page/register_login/login.dart';
import 'package:askexpertapp/page/register_login/register.dart';
import 'package:askexpertapp/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;

class welcomePage extends StatefulWidget {
  const welcomePage({Key? key}) : super(key: key);

  @override
  State<welcomePage> createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage> {
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  );

  @override
  void initState() {
    routes("welcomePage");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome",
          style: TextStyle(
            color: Color(Config.textColor),
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [],
        elevation: 0,
        centerTitle: false,
        backgroundColor: const Color(Config.appbarBg),
      ),
      backgroundColor: const Color(Config.appbarBg),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(flex: 8, child: Placeholder()),

              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
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
                              color: Color(Config.buttonSecondary),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 50),
                            primary: Color(Config.buttonPrimary),
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
                            Get.to(register());
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(Config.buttonPrimary),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 50),
                            primary: Color(Config.buttonSecondary),
                            elevation: 5,
                            shape: shape,
                            //side: BorderSide(width: 1,color: Color(Config.textColor),)
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
