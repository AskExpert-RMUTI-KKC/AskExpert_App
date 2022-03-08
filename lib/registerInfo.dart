import 'dart:convert';
import 'package:askexpertapp/registerInfo.dart';
import 'package:askexpertapp/registerPic.dart';
import 'package:flutter/material.dart';
import 'config/config.dart';
import 'dart:convert';
import 'package:askexpertapp/register.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import "dart:io";
import 'config/config.dart';
import 'package:get/get.dart';

class registerInfo extends StatefulWidget {
  const registerInfo({Key? key}) : super(key: key);

  @override
  _registerInfoState createState() => _registerInfoState();
}

class _registerInfoState extends State<registerInfo> {
  @override
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _userName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _registerCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({
      'firstName': _firstName.text,
      'lastName': _lastName.text,
      'userName': _userName.text
    });
    String? _authen = await tokenStore.getToken();
    print("body ${body}");
    print("_authen ${_authen}");
    var url = Uri.parse('${Config.API_URL}/user/setuserinfo');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${_authen}"
    });
    Map resMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('\nResponse status: ${response.statusCode}');
      print('\nResponse message: ${resMap["message"]}');
      print('\nResponse body data: ${resMap["data"]}');
      Get.to(registerPicProgile());
    } else {
      print('\nResponse message: ${resMap["message"]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Info"),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // TextFormField(
                  //   decoration: new InputDecoration(label: Text("UserName")),
                  // ),
                  TextFormField(
                    decoration: new InputDecoration(label: Text("firstName")),
                    keyboardType: TextInputType.emailAddress,
                    controller: _firstName,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "please enter firstName";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: new InputDecoration(label: Text("lastName")),
                    controller: _lastName,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "please enter lastName";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        new InputDecoration(label: Text("userName")),
                    controller: _userName,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "please enter userName";
                      } else {
                        return null;
                      }
                    },
                  ),
                  // TextFormField(
                  //   decoration: new InputDecoration(label: Text("re-PassWord")),
                  //   obscureText: true,
                  // ),
                  SizedBox(
                    width: 300,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          //primary: Colors.red, // foreground
                          ),
                      onPressed: () {
                        bool pass = _formKey.currentState!.validate();
                        if (pass) {
                          // TODO : pass
                          //_formKey.currentState!.reset();
                          _registerCallApi();
                          print("firstName : ${_firstName.text}");
                          print("passwlrd : ${_lastName.text}");
                          print("userName : ${_userName.text}");
                        }
                      },
                      child: Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
