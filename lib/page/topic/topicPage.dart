import 'dart:convert';

import 'package:askexpertapp/config/config.dart';
import 'package:askexpertapp/dataModel/topicDataModel.dart';
import 'package:askexpertapp/page/topic/commentPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:askexpertapp/utils/storageToken.dart';

class topicPage extends StatefulWidget {
  const topicPage({Key? key}) : super(key: key);

  @override
  _topicPageState createState() => _topicPageState();
}

class _topicPageState extends State<topicPage> {
  List<topicDataModel> topics = List.generate(
    0,
    (index) => topicDataModel(),
  );

  Future<void> topicCall() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await tokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.apiTopicFindAll}');
    print('\n URL :${url.toString()}');
    var response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_tokenJwt}"
    });
    Map resMap = jsonDecode(response.body);

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    setState(() {
      for (int i = 0; i < resMap["data"].length; i++) {
        topics.add(topicDataModel.fromJson(resMap["data"][i]));
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

  @override
  void initState() {
    topicCall();
    super.initState();
  }

  Future<void> LikePushButton(
      String? contentId, int? status, String? topicName) async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({
      'likeContentId': contentId,
      'likeStatus': status,
    });
    print("body ${body}");
    String? _tokenJwt = await tokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("body : ${body}");
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.apiLikeSet}');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_tokenJwt}"
    });

    Map resMap = jsonDecode(response.body);

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');

    if (status == 0) {
      Get.snackbar(
        'UNLIKE',
        '$topicName',
        icon: Icon(FontAwesomeIcons.heartCrack, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        animationDuration: Duration(seconds: 1),
      );
    } else {
      Get.snackbar(
        'LIKE',
        '$topicName',
        icon: Icon(FontAwesomeIcons.heartCircleBolt, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        animationDuration: Duration(seconds: 1),
      );
    }
  }

  Widget buildImageProfile(String index) => ClipRRect(
        // backgroundImage: CachedNetworkImageProvider(
        //   '${Config.imgProfile}$index',
        // ),
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          imageUrl: '${ConfigApp.imgProfile}$index',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          // errorWidget: (context, url, error) => Container(
          //   color: Colors.black12,
          //   child: Icon(FontAwesomeIcons.person, color: Colors.black),
          // ), // Container
          //
          maxHeightDiskCache: 100,
          maxWidthDiskCache: 100,
          cacheManager: ConfigApp.profileCache,
        ),
      );

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TOPIC ALL',
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
          itemBuilder: (context, index) => Card(
            child: ListTile(
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
                            Text(
                                'Username : ${topics[index].userInfoData?.userName}'),
                            Text(
                                'Expert : ${topics[index].userInfoData?.expert}'),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Headline : ${topics[index].topicHeadline}'),
                            Text('Group : ${topics[index].topicGroup}'),
                            Text('${topics[index].topicCaption}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.bookOpenReader),
                      Text('${topics[index].topicReadCount}'),
                      Icon(FontAwesomeIcons.comment),
                      Text('${topics[index].topicCommentCount}'),
                      IconButton(
                          onPressed: () {}, icon: Icon(FontAwesomeIcons.btc)),
                      Text('${topics[index].topicDonateCount}'),
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
                      Text('${topics[index].topicLikeCount}'),
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
              onTap: () {
                Get.to(commentPage(), arguments: topics[index]);
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>topics(fruitDataModel: topics[index],)));
              },
            ),
          ),
        ),
      ), // ListView.builder
    );
  }
}
