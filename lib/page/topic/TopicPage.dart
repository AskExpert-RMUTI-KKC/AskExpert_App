import 'dart:convert';

import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/TopicDataModel.dart';
import 'package:askexpertapp/dataModel/UserDataModel.dart';
import 'package:askexpertapp/page/topic/CommentPage.dart';
import 'package:askexpertapp/page/topic/TopicCard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:intl/intl.dart';
import 'TopicLogic.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({Key? key}) : super(key: key);

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  List<TopicDataModel> topics = List.generate(
    0,
    (index) => TopicDataModel(),
  );

  Future<void> topicCall() async {
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
      for (int i = 0; i < resMap["data"].length; i++) {
        topics.add(TopicDataModel.fromJson(resMap["data"][i]));
      }
      print('\nResponse topicAll: ${topics.length}');
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future<void> Refresh() async {
    setState(() {
      topics = [];
      topicCall();
    });

    //TODO : https://www.youtube.com/watch?v=eENDlIgadr4&list=WL&index=8&ab_channel=JohannesMilke
  }

  // Future<void> topicReadCount(String? contentId) async {
  //   String? _tokenJwt = await tokenStore.getToken();
  //   _tokenJwt = "Bearer " + _tokenJwt!;
  //   print("_tokenJwt : ${_tokenJwt}");
  //
  //   var url = Uri.parse('${ConfigApp.apiTopicRead}');
  //   print('\n URL :${url.toString()}');
  //   var response = await http.post(url, body: contentId, headers: {
  //     "Accept": "application/json",
  //     "content-type": "application/json",
  //     "Authorization": "${_tokenJwt}"
  //   });
  //   Map resMap = jsonDecode(utf8.decode(response.bodyBytes));
  //
  //   print('\nResponse status: ${response.statusCode}');
  //   print('\nResponse message: ${resMap["message"]}');
  //   print('\nResponse body data: ${resMap["data"]}');
  // }

  @override
  void initState() {
    topicCall();
    String i = NumberFormat.compact().format(1000000000000);
    print("${i}");
    super.initState();
  }

  // Widget buildImageProfile(String index) => ClipRRect(
  //       // backgroundImage: CachedNetworkImageProvider(
  //       //   '${Config.imgProfile}$index',
  //       // ),
  //       borderRadius: BorderRadius.circular(100),
  //       child: CachedNetworkImage(
  //         imageUrl: '${ConfigApp.imgProfile}$index',
  //         width: 60,
  //         height: 60,
  //         fit: BoxFit.cover,
  //         placeholder: (context, url) => Center(
  //           child: CircularProgressIndicator(),
  //         ),
  //         // errorWidget: (context, url, error) => Container(
  //         //   color: Colors.black12,
  //         //   child: Icon(FontAwesomeIcons.person, color: Colors.black),
  //         // ), // Container
  //         //
  //
  //         cacheManager: ConfigApp.profileCache,
  //         // maxHeightDiskCache: 100,
  //         // maxWidthDiskCache: 100,
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TOPIC',
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
      body: RefreshIndicator(
        onRefresh: Refresh,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: topics.length,
          itemBuilder:
              (context, index) => /*TopicCardPage(topics: topics[index])*/ Card(
            child: ListTile(
              onTap: () {
                topicReadCount(topics[index].topicId);
                Get.to(CommentPage(), arguments: topics[index]);
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>topics(fruitDataModel: topics[index],)));
              },
              title: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      buildImageProfile(
                          '${topics[index].userInfoData?.profilePic}'),
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
                            Text('${topics[index].userInfoData?.userName}'),
                            Row(children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(3, 2, 3, 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            10.0) //                 <--- border radius here
                                        ),
                                    color: Colors.black),
                                child: Text(
                                  '${topics[index].userInfoData?.expert}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: topics[index]
                                              .userInfoData
                                              ?.verifyStatus ==
                                          false
                                      ? Icon(FontAwesomeIcons.square,
                                          color: Colors.white)
                                      : Icon(FontAwesomeIcons.squareCheck,
                                          color: Colors.green)),
                            ]),
                          ],
                        ),
                      )
                    ],
                  ),
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
                                '${topics[index].topicHeadline}',
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
                                    '${topics[index].topicGroup}',
                                    style: TextStyle(color: Colors.white),
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
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.bookOpenReader),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text(
                            '${NumberFormat.compact().format(topics[index].topicReadCount)}'),
                      ),
                      Icon(FontAwesomeIcons.comment),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                            '${NumberFormat.compact().format(topics[index].topicCommentCount)}'),
                      ),
                      IconButton(
                          onPressed: () {
                            //TODO: DONATE PAGE
                            donateSheet(
                                topics[index].topicId,
                                topics[index].topicHeadline,
                                topics[index].userInfoData?.userInfoId,
                                topics[index].userInfoData?.profilePic,
                                topics[index].userInfoData?.userName);
                            /*Get.bottomSheet(
                              Container(
                                child: Column(
                                  children: [
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
                            '${NumberFormat.compact().format(topics[index].topicDonateCount)}'),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (topics[index].likeStatus == 0) {
                                topics[index].likeStatus = 1;
                                topics[index].topicLikeCount =
                                    (topics[index].topicLikeCount! + 1);
                              } else {
                                topics[index].likeStatus = 0;
                                topics[index].topicLikeCount =
                                    (topics[index].topicLikeCount! - 1);
                              }
                              LikePushButton(
                                  topics[index].topicId,
                                  topics[index].likeStatus,
                                  topics[index].topicHeadline);
                            });
                          },
                          icon: topics[index].likeStatus == 0
                              ? Icon(FontAwesomeIcons.heart,
                                  color: Colors.black)
                              : Icon(FontAwesomeIcons.heartCircleCheck,
                                  color: Colors.red)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text('${topics[index].topicLikeCount}'),
                      ),
                    ],
                  )
                ],
              ),
              // TODO: ให้มันแสดงรูปและจัดระเบียบการแสดงผล พร้อมส่งข้อมูลไปหน้าทัดไป
              // leading: SizedBox(
              //   width: 50,
              //   height: 50,
              //   child: Image.network(topics[index].ImageUrl),
              // ),
            ),
          ),
        ),
      ), // ListView.builder
    );
  }
}
