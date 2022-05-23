import 'dart:convert';
import 'dart:typed_data';
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
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/ExpertDataModel.dart';
import 'package:askexpertapp/dataModel/TopicDataModel.dart';
import 'package:askexpertapp/dataModel/UserDataModel.dart';
import 'package:askexpertapp/page/topic/CommentPage.dart';
import 'package:askexpertapp/page/topic/TopicCard.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../config/ConfigApp.dart';
import '../../dataModel/TopicGroupDataModel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<TopicGroupDataModel> topicGroupList = [];
  String? topicGroupSelected;
  late Future getTopicGroupList;

  List<ExpertDataModel> expertList = [];
  String? expertSelected;
  late Future getExpertList;

  final _keyword = TextEditingController();

  List<String> searchLooking = ["Topic", "User"];
  String? searchLookingSelected;

  List<TopicDataModel> topics = List.generate(
    0,
    (index) => TopicDataModel(),
  );

  List<UserDataModel> users = List.generate(
    0,
    (index) => UserDataModel(),
  );

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
      params['expertGroupId'] = "All";
      params['expertPath'] = "All ทั้งหมด";
      expertList.add(ExpertDataModel.fromJson(params));

      for (int i = 0; i < resMap["data"].length; i++) {
        expertList.add(ExpertDataModel.fromJson(resMap["data"][i]));
      }

      expertSelected = expertList[0].expertGroupId;
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
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
      params['topicGroupId'] = "All";
      params['topicGroupPath'] = "All ทั้งหมด";
      topicGroupList.add(TopicGroupDataModel.fromJson(params));

      for (int i = 0; i < resMap["data"].length; i++) {
        topicGroupList.add(TopicGroupDataModel.fromJson(resMap["data"][i]));
      }

      topicGroupSelected = topicGroupList[0].topicGroupId;
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }
  Future<void> SearchTopic() async{

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.apiTopicFindAll}');
    print('\n URL :${url.toString()}');
    var response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_tokenJwt}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    setState(() {
      for (int i = 0; i < resMap["data"].length; i++) {
        topics.add(TopicDataModel.fromJson(resMap["data"][i]));
      }
      print('\nResponse topicAll: ${topics.length}');
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');

    setState(() {
      users=[];
    });
  }
  Future<void> SearchUser() async{



    setState(() {
      topics=[];
    });
  }
  Future<void> SearchClick() async {
    if (searchLookingSelected == "Topic") {
      SearchTopic();
    } else if (searchLookingSelected == "User") {
      SearchUser();
    } else {

    }
  }

  @override
  void initState() {
    expertListCallApi();
    topicGroupListCallApi();

    searchLookingSelected = searchLooking[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
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
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                  color: Color(ConfigApp.buttonSecondary))),
                        ),
                        value: searchLookingSelected,
                        items: searchLooking
                            .map((DataList) => DropdownMenuItem(
                                  child: Text('${DataList}'),
                                  value: DataList,
                                ))
                            .toList(),
                        onChanged: (item) => setState(() {
                          searchLookingSelected = item;
                        }),
                        validator: (input) {
                          if (input == null) {
                            return "please select SearchType";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    searchLookingSelected == "Topic"
                        ? Column(
                            children: <Widget>[
                              Text("หมวดหมู่ของหัวข้อ"),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide(
                                            color: Color(
                                                ConfigApp.buttonSecondary))),
                                  ),
                                  value: topicGroupSelected,
                                  items: topicGroupList
                                      .map((DataList) => DropdownMenuItem(
                                            child: Text(
                                                '${DataList.topicGroupPath}'),
                                            value: DataList.topicGroupId,
                                          ))
                                      .toList(),
                                  onChanged: (item) => setState(() {
                                    topicGroupSelected = item;
                                  }),
                                  // validator: (input) {
                                  //   if (input == null) {
                                  //     return "please enter Expert";
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // },
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    searchLookingSelected == "User"
                        ? Column(
                            children: <Widget>[
                              Text("ความเชี่ยวชาณ"),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide(
                                            color: Color(
                                                ConfigApp.buttonSecondary))),
                                  ),
                                  value: expertSelected,
                                  items: expertList
                                      .map((DataList) => DropdownMenuItem(
                                            child:
                                                Text('${DataList.expertPath}'),
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
                              )
                            ],
                          )
                        : Container(),
                    TextFormField(
                      cursorColor: Color(ConfigApp.cursorColor),
                      decoration: const InputDecoration(
                          icon: Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Color(ConfigApp.iconEmail),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                  color: Color(ConfigApp.buttonSecondary))),
                          label: Text("Keyword"),
                          hintText: "ทำไมโลกถึงแบน"),
                      controller: _keyword,
                      // validator: (input) {
                      //   if (input!.isEmpty) {
                      //     return "please enter Email";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                    ),
                    topics.isNotEmpty ? Container(

                    ) : Container(),
                    users.isNotEmpty ? Container(

                    ) : Container(),
                  ],
                ),
              )),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    primary: Color(ConfigApp.buttonSecondary),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    //side: BorderSide(width: 1,color: Color(Config.textColor),)
                  ),
                  onPressed: () {
                    SearchClick();
                  },
                  child: Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(ConfigApp.buttonPrimary),
                    ),
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
