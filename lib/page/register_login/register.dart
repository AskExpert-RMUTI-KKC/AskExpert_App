import 'dart:convert';
import 'package:askexpertapp/config/config.dart';
import 'package:askexpertapp/page/register_login/registerInfo.dart';
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

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _passWord = TextEditingController();
  final _passWord2 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _registerCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({'email': _email.text, 'passWord': _passWord.text});
    print("body ${body}");
    var url = Uri.parse('${Config.apiRegister}');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    Map resMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('\nResponse status: ${response.statusCode}');
      print('\nResponse message: ${resMap["message"]}');
      print('\nResponse body data: ${resMap["data"]}');

      //SAVE TOKEN
      await tokenStore.setToken(resMap["data"]);
      String? getToken = await tokenStore.getToken();
      print("data SecureStorage : ${getToken}");
      Get.to(registerInfo());
    } else {
      print('\nResponse message: ${resMap["message"]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
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
                    decoration: new InputDecoration(label: Text("Email")),
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "plass enter Email";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: new InputDecoration(label: Text("PassWord")),
                    obscureText: true,
                    controller: _passWord,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "please enter PassWord";
                      } else if (_passWord.text != _passWord2.text) {
                        return "password not match!";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        new InputDecoration(label: Text("ReEnter-PassWord")),
                    obscureText: true,
                    controller: _passWord2,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "please enter PassWord";
                      } else if (_passWord.text != _passWord2.text) {
                        return "password not match!";
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
                          print("email : ${_email.text}");
                          print("passwlrd : ${_passWord.text}");
                        }
                      },
                      child: Text('Register'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
