import 'dart:convert';
import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/ExpertDataModel.dart';
import 'package:askexpertapp/page/NavigationBar.dart';
import 'package:askexpertapp/page/register_login/RegisterPic.dart';
import 'package:askexpertapp/page/topic/CommentPage.dart';
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

import '../dataModel/TopicGroupDataModel.dart';

class TopicAddPage extends StatefulWidget {
  const TopicAddPage({Key? key}) : super(key: key);

  @override
  State<TopicAddPage> createState() => _TopicAddPageState();
}

class _TopicAddPageState extends State<TopicAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _topicHeadline = TextEditingController();
  final _topicCaption = TextEditingController();

  List<TopicGroupDataModel> topicGroupList = [];
  String? topicGroupSelected;
  late Future getTopicGroupList;

  Future<void> _createTopicCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({
      'topicHeadline': _topicHeadline.text,
      'topicCaption': _topicCaption.text,
      'topicGroupId': topicGroupSelected,
    });
    String? _authen = await TokenStore.getToken();
    _authen = "Bearer " + _authen!;
    print("body : ${body}");
    print("_authen : ${_authen}");
    var url = Uri.parse('${ConfigApp.apiTopicAdd}');
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
      print('\n\n\n${resMap["data"]["topicId"]}\n\n\n\n\n');
      // Get.offAll(NavigationBarPage(),arguments: '0');
      Get.offAll(NavigationBarPage(),arguments: '0');
      String topicId = resMap["data"]["topicId"].toString();
      Get.to(CommentPage(),arguments: topicId);
    }
    else{
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

  Future<void> topicGroupListCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.apiTopicGroupListFindAll}');
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
        topicGroupList.add(TopicGroupDataModel.fromJson(resMap["data"][i]));
      }
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  @override
  void initState() {
    topicGroupListCallApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CreateTopic",
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
                      Column(
                        children: <Widget>[
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                            child: TextFormField(
                              maxLength: 64,
                              decoration: const InputDecoration(
                                label: Text("topicHeadline"),
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
                              controller: _topicHeadline,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "please enter topicHeadline";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                            child: TextFormField(
                                maxLength: 512,
                                maxLines: 5,
                              decoration: const InputDecoration(
                                label: Text("topicCaption"),
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
                              controller: _topicCaption,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "please enter topicCaption";
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
                          value: topicGroupSelected,
                          items: topicGroupList
                              .map((DataList) => DropdownMenuItem(
                            child: Text('${DataList.topicGroupPath}'),
                            value: DataList.topicGroupId,
                          ))
                              .toList(),
                          onChanged: (item) => setState(() {
                            topicGroupSelected = item;
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
                            if (pass) {
                              //_formKey.currentState!.reset();
                              _createTopicCallApi();
                              print("topicHeadline : ${_topicHeadline.text}");
                              print("topicCaption : ${_topicCaption.text}");
                            }
                          },
                          child: Text(
                            'Create Topic',
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
