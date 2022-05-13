import 'dart:convert';
import 'dart:developer';

import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/CommentDataModel.dart';
import 'package:askexpertapp/dataModel/TopicDataModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;

import '../../utils/storageToken.dart';
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
  List<CommentDataModel> comments = List.generate(
    0,
    (index) => CommentDataModel(),
  );
  TopicDataModel topic = new TopicDataModel();

  Future<void> commentCall(String? topicId) async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    var url = Uri.parse('${ConfigApp.apiCommentFindAll}');
    var response = await http.post(url, body: topicId);
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');

    setState(() {
      for (int i = 0; i < resMap["data"].length; i++) {
        comments.add(CommentDataModel.fromJson(resMap["data"][i]));
      }
      print('\nResponse topicAll: ${comments.length}');
    });

    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future<void> topicCall(topicId) async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

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
      topic = TopicDataModel.fromJson(resMap["data"][0]);
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future<void> Refresh() async {
    setState(() {
      comments = [];
      topic = new TopicDataModel();
      topicCall(topicId);
      commentCall(topicId);
    });

    //TODO : https://www.youtube.com/watch?v=eENDlIgadr4&list=WL&index=8&ab_channel=JohannesMilke
  }

  @override
  void initState() {
    topicId = Get.arguments;
    topicCall(topicId);
    commentCall(topicId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      //Text('${topic.topicCaption}\n ${topicId}\n ${topic.topicGroup}\n ${topic.topicHeadline}\n ')
      body: RefreshIndicator(
        onRefresh: Refresh,
        child: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    InkWell(
                      child: buildImageProfile(
                          '${topic.userInfoData?.profilePic}'),
                      onTap: () {
                        print(
                            "Test ${topic.userInfoData?.userInfoId}");
                        Get.to(ProfileTopicPage(),
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
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      width: c_width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${topic.userInfoData?.userName}'),
                          Row(children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(3, 2, 3, 2),
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  if (topic
                                      .userInfoData
                                      ?.verifyStatus ==
                                      true)
                                    Padding(
                                        padding:
                                        EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Icon(
                                            FontAwesomeIcons.circleCheck,
                                            color: Colors.lightBlueAccent)),
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
                    Text('${topic.createdDate}'),
                  ],),
                //TODO today
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        width: c_width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${topic.topicHeadline}',
                              maxLines: 2,
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(3, 2, 3, 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            10.0) //                 <--- border radius here
                                    ),
                                    color: Colors.black),
                                child: Text(
                                  '${topic.topicGroupName}',
                                  style: TextStyle(color: Colors.white),
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(
                          '${NumberFormat.compact().format(topic.topicReadCount)}'),
                    ),
                    Icon(FontAwesomeIcons.comment),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                            : Icon(FontAwesomeIcons.heartCircleCheck,
                            color: Colors.red)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text('${topic.topicLikeCount}'),
                    ),
                  ],
                ),
                Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('${comments[index].commentCaption}'),
                          onTap: () {},

                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
