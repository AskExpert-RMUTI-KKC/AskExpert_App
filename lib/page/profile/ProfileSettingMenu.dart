import 'dart:ffi';

import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/page/NavigationBar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../dataModel/ExpertDataModel.dart';
import '../../utils/UtilsImg.dart';
import '../WelcomePage.dart';
import 'dart:convert';
import 'dart:io';

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

  final _telNumber = TextEditingController();
  final _priceCall = TextEditingController();
  final _priceVideo = TextEditingController();
  final _liveLink = TextEditingController();

  List<ExpertDataModel> expertList = [];
  String? expertSelected;
  late Future getExpertList;
  UserDataModel user = UserDataModel();

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
      'telNumber':_telNumber.text,
      'priceCall':_priceCall.text,
      'priceVideo':_priceVideo.text,
      'liveLink':_liveLink.text,
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
      if(imageFile != null){
        UtilsImage().uploadImgProfile(imageFile);
      }
      Get.offAll(NavigationBarPage());
      Get.offAll(NavigationBarPage());
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
      _telNumber.text =user.telNumber!;
      _priceCall.text=user.priceCall!.toString();
      _priceVideo.text=user.priceVideo!.toString();
      _liveLink.text=user.liveLink!;
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future selectFile() async {
    final imageFile = await UtilsImage.pickImageProfile(true);
    if(imageFile!=null){
      print('\nImage File :${imageFile.path}');
      setState(() {
        final imageTemp = File(imageFile!.path);
        this.imageFile = imageTemp;
      });
    }
    else{return;}
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
                    child: imageFile == null
                        ? buildImageProfilePage('${user.profilePic}')
                        : Image.file(imageFile!,height: 256,width: 256, fit: BoxFit.cover),
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

                          //TODO
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                            child: TextFormField(
                              maxLength: 16,
                              decoration: const InputDecoration(
                                label: Text("_telNumber"),
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
                              controller: _telNumber,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "please enter _telNumber";
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
                                label: Text("_priceCall"),
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
                              controller: _priceCall,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "please enter _priceCall";
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
                                label: Text("_priceVideo"),
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
                              controller: _priceVideo,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "please enter _priceVideo";
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
                                label: Text("_liveLink"),
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
                              controller: _liveLink,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "please enter _liveLink";
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
                      Text('ความชำนาญพิเศษ(หากมี)',style: TextStyle(fontSize: 16),),
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
                              expertSelected = "none";
                              return null;
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
                Container(
                  height: 100,
                  width: 300,
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
