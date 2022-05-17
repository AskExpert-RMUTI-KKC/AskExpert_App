import 'dart:convert';
import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/ExpertDataModel.dart';
import 'package:askexpertapp/page/NavigationBar.dart';
import 'package:askexpertapp/page/register_login/RegisterPic.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import "dart:io";
import 'package:get/get.dart';

import '../../utils/UtilsImg.dart';

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
  final _userCaption = TextEditingController();
  List<ExpertDataModel> expertList = [];
  String? expertSelected;
  late Future getExpertList;
  File? imageFile;

  Future<void> _registerCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({
      'firstName': _firstName.text,
      'lastName': _lastName.text,
      'userName': _userName.text,
      'userCaption': _userCaption.text,
      'expertGroupId': expertSelected,
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
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    if (response.statusCode == 200 && resMap["message"] == null) {
      UtilsImage().uploadImgProfile(imageFile);
      Get.offAll(NavigationBarPage());
    } else {
      Get.snackbar(
        "Register Report Status",
        '${resMap["message"]}',
        icon: Icon(FontAwesomeIcons.person, color: Colors.black),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(ConfigApp.warningSnackBar),
        colorText: Color(ConfigApp.warningSnackBarText),
      );
    }
  }

  Future<void> expertListCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.apiExpertFindAll}');
    print('\n URL :${url.toString()}');
    var response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    setState(() {
      for (int i = 0; i < resMap["data"].length; i++) {
        expertList.add(ExpertDataModel.fromJson(resMap["data"][i]));
      }
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future<String> awaitExpertList() async {
    await expertListCallApi();
    return "Success";
  }

  Future selectFile() async {
    final imageFile = await UtilsImage.pickImageProfile(true);
    if (imageFile != null) {
      print('\nImage File :${imageFile.path}');
      setState(() {
        final imageTemp = File(imageFile!.path);
        this.imageFile = imageTemp;
        UtilsImage().uploadImgProfile(imageFile);
      });
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    getExpertList = awaitExpertList();
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
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          selectFile();
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          width: 256,
                          height: 256,
                          child: imageFile == null
                              ? Container(
                                  height: 256,
                                  width: 256,
                                  child: Placeholder(),
                                )
                              : Image.file(imageFile!,
                                  height: 256, width: 256, fit: BoxFit.cover),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                            child: TextFormField(
                              maxLength: 16,
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
                                        color:
                                            Color(ConfigApp.buttonSecondary))),
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
                            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                            child: TextFormField(
                              maxLength: 16,
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
                                        color:
                                            Color(ConfigApp.buttonSecondary))),
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
                            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                            child: TextFormField(
                              maxLength: 16,
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
                                        color:
                                            Color(ConfigApp.buttonSecondary))),
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                            child: TextFormField(
                              maxLength: 512,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                label: Text("UserCaption"),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                        color:
                                            Color(ConfigApp.buttonSecondary))),
                              ),
                              controller: _userCaption,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "please enter userCaption";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100,
                        width: 200,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
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
                          value: expertSelected,
                          items: expertList
                              .map((DataList) => DropdownMenuItem(
                                    child: Text('${DataList.expertPath}'),
                                    value: DataList.expertGroupId,
                                  ))
                              .toList(),
                          onChanged: (item) => setState(() {
                            expertSelected = item;
                          }),
                          validator: (input) {
                            if (input == null) {
                              return "please enter Expert";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),

                      // TODO : Expert List DropDown
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
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
                            if (imageFile == null) {
                              pass = false;
                              Get.snackbar(
                                "Register Report Status",
                                'Please Upload Image Profile',
                                icon: Icon(FontAwesomeIcons.person, color: Colors.black),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Color(ConfigApp.warningSnackBar),
                                colorText: Color(ConfigApp.warningSnackBarText),
                              );
                            }
                            if (pass) {
                              //_formKey.currentState!.reset();
                              _registerCallApi();
                              print("firstName : ${_firstName.text}");
                              print("lastName : ${_lastName.text}");
                              print("userName : ${_userName.text}");
                              print("userCaption : ${_userCaption.text}");
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
