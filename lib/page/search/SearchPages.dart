import 'dart:convert';
import 'dart:typed_data';
import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/ExpertDataModel.dart';
import 'package:askexpertapp/page/NavigationBar.dart';
import 'package:askexpertapp/page/profile/ProfilePage.dart';
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
import '../topic/TopicLogic.dart';

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

  bool isSearch = false;

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

  Future<void> SearchTopic() async {
    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var body = jsonEncode({
      'topicHeadLine': _keyword.text,
      'topicGroup': topicGroupSelected,
    });

    var url = Uri.parse('${ConfigApp.apiTopicFindByText}');
    print('\n URL :${url.toString()}');
    var response = await http.post(url,body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
      //,"Authorization": "${_tokenJwt}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    setState(() {
      users = [];
      topics = [];
      for (int i = 0; i < resMap["data"].length; i++) {
        isSearch = false;
        topics.add(TopicDataModel.fromJson(resMap["data"][i]));
      }
      print('\nResponse topicAll: ${topics.length}');
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');

  }

  Future<void> SearchUser() async {
    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var body = jsonEncode({
      'userName': _keyword.text,
      'expertGroup': expertSelected,
    });

    var url = Uri.parse('${ConfigApp.apiUserFindByText}');
    print('\n URL :${url.toString()}');
    var response = await http.post(url,body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      //"Authorization": "${_tokenJwt}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    setState(() {
      topics = [];
      users = [];
      for (int i = 0; i < resMap["data"].length; i++) {
        isSearch = false;
        users.add(UserDataModel.fromJson(resMap["data"][i]));
      }
      print('\nResponse topicAll: ${topics.length}');
    });
  }

  Future<void> SearchClick() async {
    if (searchLookingSelected == "Topic") {
      SearchTopic();
    } else if (searchLookingSelected == "User") {
      SearchUser();
    } else {}
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
    double c_width = MediaQuery.of(context).size.width * 0.7;

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
                    topics.isNotEmpty
                        ? Container(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              itemCount: topics.length,
                              itemBuilder: (context,
                                  index) => /*TopicCardPage(topics: topics[index])*/ Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(CommentPage(),
                                        arguments:
                                            topics[index].topicId.toString());
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 0, 2),
                                        child: Row(
                                          children: <Widget>[
                                            InkWell(
                                              child: buildImageProfile(
                                                  '${topics[index].userInfoData?.profilePic}'),
                                              onTap: () {
                                                print(
                                                    "Test ${topics[index].userInfoData?.userInfoId}");
                                                Get.to(ProfilePage(),
                                                    arguments: topics[index]
                                                        .userInfoData
                                                        ?.userInfoId);
                                              },
                                            ),
                                            // Container(
                                            //     height: 50,
                                            //     width: 50,
                                            //     child: Image.network(
                                            //         '${Config.imgProfile}')
                                            // ),
                                            // const Icon(
                                            //   FontAwesomeIcons.btc,
                                            //   size: 50,
                                            // ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                              width: c_width,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                      '${topics[index].userInfoData?.userName}'),
                                                  Row(children: <Widget>[
                                                    topics[index]
                                                                .userInfoData
                                                                ?.expert !=
                                                            null
                                                        ? Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    3, 2, 3, 2),
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(
                                                                                10.0) //                 <--- border radius here
                                                                            ),
                                                                    color: Colors
                                                                        .black),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  '${topics[index].userInfoData?.expert}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                if (topics[index]
                                                                        .userInfoData
                                                                        ?.verifyStatus ==
                                                                    true)
                                                                  Padding(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              10,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child: Icon(
                                                                          FontAwesomeIcons
                                                                              .circleCheck,
                                                                          color:
                                                                              Colors.lightBlueAccent)),
                                                              ],
                                                            ),
                                                          )
                                                        : Container(),
                                                  ]),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 2, 0, 2),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(topics[index].createdDate!))}'),
                                          ],
                                        ),
                                      ),
                                      topics[index].topicImg != null
                                          ? Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 2, 0, 2),
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 0),
                                                    child: Container(
                                                      width: c_width,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            '${topics[index].topicHeadline}',
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                          Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          3,
                                                                          2,
                                                                          3,
                                                                          2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0) //                 <--- border radius here
                                                                          ),
                                                                      color: Colors
                                                                          .black),
                                                              child: Text(
                                                                '${topics[index].topicGroupName}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                          Text(
                                                            '${topics[index].topicCaption}',
                                                            maxLines: 4,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                    'assets/images/bgText.jpg'),
                                                Text(
                                                  '${topics[index].topicHeadline}',
                                                  maxLines: 5,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  left: 10,
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              3, 2, 3, 2),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0) //                 <--- border radius here
                                                                  ),
                                                          color: Colors.black),
                                                      child: Text(
                                                        '${topics[index].topicGroupName}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                )
                                              ],
                                            ),
                                      topics[index].topicImg != null
                                          ? Image.network(
                                              '${ConfigApp.imgTopic}${topics[index].topicImg?[0].imgName}')
                                          : Container(),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.bookOpenReader),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Text(
                                                '${NumberFormat.compact().format(topics[index].topicReadCount)}'),
                                          ),
                                          Icon(FontAwesomeIcons.comment),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                                '${NumberFormat.compact().format(topics[index].topicCommentCount)}'),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                donateSheet(
                                                    topics[index].topicId,
                                                    topics[index].topicHeadline,
                                                    topics[index]
                                                        .userInfoData
                                                        ?.userInfoId,
                                                    topics[index]
                                                        .userInfoData
                                                        ?.profilePic,
                                                    topics[index]
                                                        .userInfoData
                                                        ?.userName);
                                                /*Get.bottomSheet(
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(title: Text('TEST'),),
                                    Text("Test")
                                  ],
                                ),
                              ),
                              elevation: 20,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                              ),
                            );*/
                                              },
                                              icon: Icon(FontAwesomeIcons.btc)),
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            child: Text(
                                                '${NumberFormat.compact().format(topics[index].topicDonateCount)}'),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (topics[index]
                                                          .likeStatus ==
                                                      0) {
                                                    topics[index].likeStatus =
                                                        1;
                                                    topics[index]
                                                            .topicLikeCount =
                                                        (topics[index]
                                                                .topicLikeCount! +
                                                            1);
                                                  } else {
                                                    topics[index].likeStatus =
                                                        0;
                                                    topics[index]
                                                            .topicLikeCount =
                                                        (topics[index]
                                                                .topicLikeCount! -
                                                            1);
                                                  }
                                                  LikePushButton(
                                                      topics[index].topicId,
                                                      topics[index].likeStatus,
                                                      topics[index]
                                                          .topicHeadline);
                                                });
                                              },
                                              icon: topics[index].likeStatus ==
                                                      0
                                                  ? Icon(FontAwesomeIcons.heart,
                                                      color: Colors.black)
                                                  : Icon(
                                                      FontAwesomeIcons
                                                          .heartCircleCheck,
                                                      color: Colors.red)),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Text(
                                                '${topics[index].topicLikeCount}'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    users.isNotEmpty ? Container(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        itemCount: users.length,
                        itemBuilder: (context,
                            index) => /*TopicCardPage(topics: topics[index])*/ Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.black, width: 4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Get.to(ProfilePage(),
                                  arguments: users[index].userInfoId);
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding:
                                  EdgeInsets.fromLTRB(10, 10, 0, 2),
                                  child: Row(
                                    children: <Widget>[
                                      InkWell(
                                        child: buildImageProfile(
                                            '${users[index].profilePic}'),
                                        onTap: () {
                                          print(
                                              "Test ${users[index].userInfoId}");
                                          Get.to(ProfilePage(),
                                              arguments: users[index].userInfoId);
                                        },
                                      ),
                                      // Container(
                                      //     height: 50,
                                      //     width: 50,
                                      //     child: Image.network(
                                      //         '${Config.imgProfile}')
                                      // ),
                                      // const Icon(
                                      //   FontAwesomeIcons.btc,
                                      //   size: 50,
                                      // ),
                                      Container(
                                        padding:
                                        const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        width: c_width,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                '${users[index].userName}'),
                                            Row(children: <Widget>[
                                              users[index].expertGroupListData !=
                                                  null
                                                  ? Container(
                                                padding: EdgeInsets
                                                    .fromLTRB(
                                                    3, 2, 3, 2),
                                                decoration:
                                                BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            10.0) //                 <--- border radius here
                                                    ),
                                                    color: Colors
                                                        .black),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '${users[index].expertGroupListData?.expertPath}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white),
                                                    ),
                                                    if (users[index].verifyStatus ==
                                                        true)
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                              10,
                                                              0,
                                                              0,
                                                              0),
                                                          child: Icon(
                                                              FontAwesomeIcons
                                                                  .circleCheck,
                                                              color:
                                                              Colors.lightBlueAccent)),
                                                  ],
                                                ),
                                              )
                                                  : Container(),
                                            ]),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ) : Container(),

                    isSearch?
                        Container(child: Text("ไม่พบผลการค้นหา"),)
                        :Container(),
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
                    isSearch = true;
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
