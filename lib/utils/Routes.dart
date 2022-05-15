import 'dart:convert';

import 'package:askexpertapp/page/NavigationBar.dart';
import 'package:askexpertapp/page/WelcomePage.dart';
import 'package:askexpertapp/page/register_login/Login.dart';
import 'package:askexpertapp/page/topic/TopicPage.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'dart:convert';
import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/page/register_login/RegisterPic.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import "dart:io";
import 'package:get/get.dart';

void routes(String check) async {
  // var body = jsonEncode({
  //   'firstName': _firstName.text,
  //   'lastName': _lastName.text,
  //   'userName': _userName.text
  // });
  String? token = await TokenStore.getToken();
  if (token != null && token != "") {
    String? _authen = await TokenStore.getToken();
    _authen = "Bearer " + _authen!;
    //print("body : ${body}");
    print("_authen : ${_authen}");
    var url = Uri.parse(ConfigApp.apiUserRefreshJWT);
    var response = await http.post(url /*, body: body*/, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_authen}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));
    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    if (response.statusCode == 200) {
      //SAVE TOKEN
      await TokenStore.setToken(resMap["data"]);
      String? getToken = await TokenStore.getToken();
      print("data SecureStorage : ${getToken}");

      Get.offAll(NavigationBarPage());
    }
    else if(response.statusCode == 403){
      Get.offAll(LoginPage());
    }
    else {
      Get.offAll(const WelcomePage());
    }
  } else {
    Get.offAll(const WelcomePage());
  }
}
