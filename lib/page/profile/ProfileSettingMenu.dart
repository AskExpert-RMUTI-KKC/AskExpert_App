import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/page/NavigationBar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:image_picker/image_picker.dart';

import '../../dataModel/ExpertDataModel.dart';
import '../WelcomePage.dart';
import 'dart:convert';

import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/UserDataModel.dart';
import 'package:askexpertapp/page/profile/ProfileSettingMenu.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'ProfileLogic.dart';

class ProfileSettingMenu extends StatefulWidget {
  const ProfileSettingMenu({Key? key}) : super(key: key);

  @override
  State<ProfileSettingMenu> createState() => _ProfileSettingMenuState();
}

class _ProfileSettingMenuState extends State<ProfileSettingMenu> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _userName = TextEditingController();
  final _userCaption = TextEditingController();
  List<ExpertDataModel> expertList = [];
  String? expertSelected;
  late Future getExpertList;
  UserDataModel user = UserDataModel();
  PlatformFile? _image;

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
      Get.offAll(NavigationBarPage(),arguments:'4');
    }
    else{
      Get.snackbar(
        "Profile Report Status",
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

  Future<void> UserCall() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var response;
    var url;
    url = Uri.parse('${ConfigApp.apiUserFindById}');
    print('\n URL :${url.toString()}');
    response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_tokenJwt}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    setState(() {
      user = UserDataModel.fromJson(resMap["data"]);
      _firstName.text = user.firstName!;
      _lastName.text =user.lastName!;
      _userName.text = user.userName!;
      _userCaption.text = user.userCaption!;
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future selectFile() async {
    final test = await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  @override
  void initState() {
    UserCall();
    expertListCallApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Setting',
          style: TextStyle(
            color: Color(ConfigApp.textColor),
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [],
        elevation: 0,
        centerTitle: false,
        backgroundColor: const Color(ConfigApp.appbarBg),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: const Color(ConfigApp.appbarBg),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () { selectFile();},
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    width: 256,
                    height: 256,
                    child: buildImageProfilePage('${user.profilePic}'),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
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
                            padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
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
                            padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
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
                            padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Verify",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(ConfigApp.buttonPrimary),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 50),
                      primary: Color(ConfigApp.buttonSecondary),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      //side: BorderSide(width: 1,color: Color(Config.textColor),)
                    ),
                  ),
                ),
                Text('VerifyStatus'),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      bool pass = _formKey.currentState!.validate();
                      if (pass) {
                        _registerCallApi();
                      }

                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(ConfigApp.buttonPrimary),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 50),
                      primary: Color(ConfigApp.buttonSecondary),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      //side: BorderSide(width: 1,color: Color(Config.textColor),)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(ConfigApp.buttonPrimary),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 50),
                      primary: Color(ConfigApp.buttonSecondary),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      //side: BorderSide(width: 1,color: Color(Config.textColor),)
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
