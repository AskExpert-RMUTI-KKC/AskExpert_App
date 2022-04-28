import 'dart:convert';
import 'package:askexpertapp/config/config.dart';
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

class RegisterInfoPage extends StatefulWidget {
  const RegisterInfoPage({Key? key}) : super(key: key);

  @override
  _RegisterInfoPageState createState() => _RegisterInfoPageState();
}

class _RegisterInfoPageState extends State<RegisterInfoPage> {
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
    String? _authen = await TokenStore.getToken();
    _authen = "Bearer " + _authen!;
    print("body : ${body}");
    print("_authen : ${_authen}");
    var url = Uri.parse('${ConfigApp.apiRegisterUpdate}');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_authen}"
    });
    Map resMap = jsonDecode(response.body);

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    if (response.statusCode == 200) {
      Get.to(RegisterImgPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Register-Info",
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
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0, 12.0, 0, 12.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                label: Text("Firstname"),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                        color: Color(ConfigApp.buttonSecondary))),
                              ),
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
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0, 12.0, 0, 12.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                label: Text("Lastname"),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                        color: Color(ConfigApp.buttonSecondary))),
                              ),
                              controller: _lastName,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "please enter lastName";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0, 12.0, 0, 12.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                label: Text("Username"),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                        color: Color(ConfigApp.buttonSecondary))),
                              ),
                              controller: _userName,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "please enter userName";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      // TODO : Expert List DropDown
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12.0, 0, 12.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(140.0),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 50),
                            primary: Color(ConfigApp.buttonSecondary),
                            elevation: 5,
                            shape: shape,
                            //side: BorderSide(width: 1,color: Color(Config.textColor),)
                          ),
                          onPressed: () {
                            bool pass = _formKey.currentState!.validate();
                            if (pass) {
                              //_formKey.currentState!.reset();
                              _registerCallApi();
                              print("firstName : ${_firstName.text}");
                              print("passwlrd : ${_lastName.text}");
                              print("userName : ${_userName.text}");
                            }
                          },
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(ConfigApp.buttonPrimary),
                            ),
                          ),
                        ),
                      )
                      // TextFormField(
                      //   decoration: new InputDecoration(label: Text("UserName")),
                      // ),

                      // TextFormField(
                      //   decoration: new InputDecoration(label: Text("re-PassWord")),
                      //   obscureText: true,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
