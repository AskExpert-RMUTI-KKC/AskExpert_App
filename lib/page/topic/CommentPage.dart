import 'dart:convert';
import 'dart:developer';

import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/CommentDataModel.dart';
import 'package:askexpertapp/dataModel/TopicDataModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;

import '../../utils/storageToken.dart';
import '../profile/ProfilePage.dart';
import '../profile/ProfileTopicPage.dart';
import 'TopicCard.dart';
import 'TopicLogic.dart';
import 'package:intl/intl.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late String topicId;
  late Future getTopic;
  List<CommentDataModel> comments = List.generate(
    0,
    (index) => CommentDataModel(),
  );
  TopicDataModel topic = new TopicDataModel();

  final _commentCaption = TextEditingController();

  Future<void> commentCall(topicId) async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    String? _authen = await TokenStore.getToken();
    _authen = "Bearer " + _authen!;
    print("_authen : ${_authen}");
    var url = Uri.parse('${ConfigApp.apiFindByContentId}');
    print('\n URL :${url.toString()}');
    var response = await http.post(url, body: topicId, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_authen}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nComment Response status: ${response.statusCode}');
    print('\nComment Response message: ${resMap["message"]}');
    print('\nComment Response body data: ${resMap["data"]}');
    print('\nComment Response resMap: ${resMap}');
    setState(() {
      for (int i = 0; i < resMap["data"].length; i++) {
        comments.add(CommentDataModel.fromJson(resMap["data"][i]));
      }
      print('\nResponse CommentAll: ${comments.length}');
    });

    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future<void> createCommentCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({
      'commentCaption': _commentCaption.text,
      'commentContentId': topicId,
      'commentIsSubComment': 0,
    });
    String? _authen = await TokenStore.getToken();
    _authen = "Bearer " + _authen!;
    print("body : ${body}");
    print("_authen : ${_authen}");
    var url = Uri.parse('${ConfigApp.apiCommentAdd}');
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
    } else {
      // Get.snackbar(
      //   "Register Report Status",
      //   '${resMap["message"]}',
      //   icon: Icon(FontAwesomeIcons.person, color: Colors.black),
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Color(ConfigApp.warningSnackBar),
      //   colorText: Color(ConfigApp.warningSnackBarText),
      // );
    }
  }

  Future<void> topicCall(topicId) async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.apiTopicFindById}');
    print('\n URL :${url.toString()}');
    var response = await http.post(url, body: topicId, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_tokenJwt}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));
    print('\nTopic Response status: ${response.statusCode}');
    print('\nTopic Response message: ${resMap["message"]}');
    print('\nTopic Response body data: ${resMap["data"]}');
    setState(() {
      topic = TopicDataModel.fromJson(resMap["data"]);
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future<void> Refresh() async {
    setState(() {
      comments = [];
      topicCall(topicId);
      commentCall(topicId);
    });

    //TODO : https://www.youtube.com/watch?v=eENDlIgadr4&list=WL&index=8&ab_channel=JohannesMilke
  }

  Future<String> awaitTopicCommentCall() async {
    await topicCall(topicId);
    return "1";
  }

  @override
  void initState() {
    topicId = Get.arguments;
    getTopic = awaitTopicCommentCall();
    commentCall(topicId);
  }

  _buildCommentAdd() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.photo),
          //   iconSize: 25.0,
          //   color: Theme.of(context).primaryColor,
          //   onPressed: () {},
          // ),
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 3,
              controller: _commentCaption,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'add comment...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.black,
            ),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (_commentCaption.text.isNotEmpty) {
                createCommentCallApi();
                _commentCaption.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      //Text('${topic.topicCaption}\n ${topicId}\n ${topic.topicGroup}\n ${topic.topicHeadline}\n ')
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: RefreshIndicator(
          onRefresh: Refresh,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                      child: FutureBuilder(
                    future: getTopic,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                InkWell(
                                  child: buildImageProfile(
                                      '${topic.userInfoData?.profilePic}'),
                                  onTap: () {
                                    print(
                                        "Test ${topic.userInfoData?.userInfoId}");
                                    Get.to(ProfilePage(),
                                        arguments:
                                            topic.userInfoData?.userInfoId);
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
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  width: c_width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('${topic.userInfoData?.userName}'),
                                      Row(children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(3, 2, 3, 2),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      10.0) //                 <--- border radius here
                                                  ),
                                              color: Colors.black),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${topic.userInfoData?.expert}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              if (topic.userInfoData
                                                      ?.verifyStatus ==
                                                  true)
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 0, 0),
                                                    child: Icon(
                                                        FontAwesomeIcons
                                                            .circleCheck,
                                                        color: Colors
                                                            .lightBlueAccent)),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(topic.createdDate!))}'),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Container(
                                    width: c_width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${topic.topicHeadline}',
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Container(
                                            padding:
                                                EdgeInsets.fromLTRB(3, 2, 3, 2),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        10.0) //                 <--- border radius here
                                                    ),
                                                color: Colors.black),
                                            child: Text(
                                              '${topic.topicGroupName}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        Text(
                                          '${topic.topicCaption}',
                                          maxLines: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.bookOpenReader),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text(
                                      '${NumberFormat.compact().format(topic.topicReadCount)}'),
                                ),
                                Icon(FontAwesomeIcons.comment),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                      '${NumberFormat.compact().format(topic.topicCommentCount)}'),
                                ),
                                IconButton(
                                    onPressed: () {
                                      donateSheet(
                                          topic.topicId,
                                          topic.topicHeadline,
                                          topic.userInfoData?.userInfoId,
                                          topic.userInfoData?.profilePic,
                                          topic.userInfoData?.userName);
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
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                      '${NumberFormat.compact().format(topic.topicDonateCount)}'),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (topic.likeStatus == 0) {
                                          topic.likeStatus = 1;
                                          topic.topicLikeCount =
                                              (topic.topicLikeCount! + 1);
                                        } else {
                                          topic.likeStatus = 0;
                                          topic.topicLikeCount =
                                              (topic.topicLikeCount! - 1);
                                        }
                                        LikePushButton(
                                            topic.topicId,
                                            topic.likeStatus,
                                            topic.topicHeadline);
                                      });
                                    },
                                    icon: topic.likeStatus == 0
                                        ? Icon(FontAwesomeIcons.heart,
                                            color: Colors.black)
                                        : Icon(
                                            FontAwesomeIcons.heartCircleCheck,
                                            color: Colors.red)),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text('${topic.topicLikeCount}'),
                                ),
                              ],
                            ),
                            Container(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8),
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: InkWell(
                                      onLongPress: () {},
                                      onTap: () {},
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              height: 30,
                                              width: 30,
                                              padding: EdgeInsets.all(0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  print(
                                                      "Test ${comments[index].userInfoData?.userInfoId}");
                                                  Get.to(ProfilePage(),
                                                      arguments: comments[index]
                                                          .userInfoData
                                                          ?.userInfoId);
                                                },
                                                child:
                                                    buildImageProfileDonateSheet(
                                                        comments[index]
                                                            .userInfoData!
                                                            .profilePic!),
                                              )),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                      '${comments[index].userInfoData?.userName}'),
                                                  Row(children: <Widget>[
                                                    Container(
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
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            '${comments[index].userInfoData?.expert}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          if (comments[index]
                                                                  .userInfoData
                                                                  ?.verifyStatus ==
                                                              true)
                                                            Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Icon(
                                                                    FontAwesomeIcons
                                                                        .circleCheck,
                                                                    color: Colors
                                                                        .lightBlueAccent)),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                                ],
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.6,
                                                  child: Text(
                                                    '${comments[index].commentCaption}',
                                                  )),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              IconButton(
                                                  onPressed: () {
                                                    donateSheet(
                                                        comments[index]
                                                            .commentId,
                                                        comments[index]
                                                            .commentCaption,
                                                        comments[index]
                                                            .userInfoData
                                                            ?.userInfoId,
                                                        comments[index]
                                                            .userInfoData
                                                            ?.profilePic,
                                                        comments[index]
                                                            .userInfoData
                                                            ?.userName);
                                                  },
                                                  icon: Icon(
                                                      FontAwesomeIcons.btc)),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                child: Text(
                                                    '${NumberFormat.compact().format(comments[index].commentDonateCount)}'),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (comments[index]
                                                              .likeStatus ==
                                                          0) {
                                                        comments[index]
                                                            .likeStatus = 1;
                                                        comments[index]
                                                                .commentLikeCount =
                                                            (comments[index]
                                                                    .commentLikeCount! +
                                                                1);
                                                      } else {
                                                        comments[index]
                                                            .likeStatus = 0;
                                                        comments[index]
                                                                .commentLikeCount =
                                                            (comments[index]
                                                                    .commentLikeCount! -
                                                                1);
                                                      }
                                                      LikePushButton(
                                                          comments[index]
                                                              .commentId,
                                                          comments[index]
                                                              .likeStatus,
                                                          comments[index]
                                                              .commentCaption);
                                                    });
                                                  },
                                                  icon: comments[index]
                                                              .likeStatus ==
                                                          0
                                                      ? Icon(
                                                          FontAwesomeIcons
                                                              .heart,
                                                          color: Colors.black)
                                                      : Icon(
                                                          FontAwesomeIcons
                                                              .heartCircleCheck,
                                                          color: Colors.red)),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                child: Text(
                                                    '${comments[index].commentLikeCount}'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Material(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  )),
                ),
                _buildCommentAdd(),
                // TextFormField(
                //   minLines: 1,
                //   maxLines: 10,
                //   decoration: const InputDecoration(
                //     // icon: Icon(
                //     //   Icons.password,
                //     //   color: Color(ConfigApp.iconEmail),
                //     // ),
                //     suffixIcon: IconButton(onPressed: createCommentCallApi, icon: Icon(FontAwesomeIcons.arrowRight)),
                //     border: OutlineInputBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(15)),
                //         borderSide:
                //         BorderSide(color: Color(ConfigApp.buttonPrimary))),
                //   ),
                //   controller: _commentCaption,
                //   validator: (input) {
                //     if (input!.isEmpty) {
                //       return "please enter PassWord";
                //     } else {
                //       return null;
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
