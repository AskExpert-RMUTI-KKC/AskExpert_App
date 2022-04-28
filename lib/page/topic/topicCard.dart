import 'dart:convert';

import 'package:askexpertapp/config/config.dart';
import 'package:askexpertapp/dataModel/topicDataModel.dart';
import 'package:askexpertapp/dataModel/userDataModel.dart';
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

import 'topicLogic.dart';

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

        cacheManager: ConfigApp.profileCache,
        // maxHeightDiskCache: 100,
        // maxWidthDiskCache: 100,
      ),
    );

Future<void> topicReadCount(String? contentId) async {
  String? _tokenJwt = await TokenStore.getToken();
  _tokenJwt = "Bearer " + _tokenJwt!;
  print("_tokenJwt : ${_tokenJwt}");

  var url = Uri.parse('${ConfigApp.apiTopicRead}');
  print('\n URL :${url.toString()}');
  var response = await http.post(url, body: contentId, headers: {
    "Accept": "application/json",
    "content-type": "application/json",
    "Authorization": "${_tokenJwt}"
  });
  Map resMap = jsonDecode(response.body);

  print('\nResponse status: ${response.statusCode}');
  print('\nResponse message: ${resMap["message"]}');
  print('\nResponse body data: ${resMap["data"]}');
}

/*
Widget topicCard(context,topicDataModel topics) => Card(
  child: ListTile(
    onTap: () {
      topicReadCount(topics.topicId);
      Get.to(commentPage(), arguments: topics);
      //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>topics(fruitDataModel: topics,)));
    },
    title: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            buildImageProfile(
                '${topics.userInfoData?.profilePic}'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      'Username : ${topics.userInfoData?.userName}'),
                  Row(children: <Widget>[
                    Text(
                        'Expert : ${topics.userInfoData?.expert}'),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: topics .userInfoData ?.verifyStatus == false
                            ? Icon(FontAwesomeIcons.square,
                            color: Colors.black)
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Headline : ${topics.topicHeadline}'),
                  Text('Group : ${topics.topicGroup}'),
                  Text('${topics.topicCaption}'),
                ],
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
              child: Text('${topics.topicReadCount}'),
            ),
            Icon(FontAwesomeIcons.comment),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text('${topics.topicCommentCount}'),
            ),
            IconButton(
                onPressed: () {
                  //TODO: DONATE PAGE
                  donateSheet(
                      topics.topicId,
                      topics.topicHeadline,
                      topics.userInfoData?.userInfoId,
                      topics.userInfoData?.profilePic,
                      topics.userInfoData?.userName);
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
              child: Text('${topics.topicDonateCount}'),
            ),
            IconButton(
                onPressed: () {
                  LikePushButton(
                      topics.topicId,
                      topics.likeStatus,
                      topics.topicHeadline);
                },
                icon: topics.likeStatus == 0
                    ? Icon(FontAwesomeIcons.heart,
                    color: Colors.black)
                    : Icon(FontAwesomeIcons.heartCircleCheck,
                    color: Colors.red)),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text('${topics.topicLikeCount}'),
            ),
          ],
        )
      ],
    ),
    // TODO: ให้มันแสดงรูปและจัดระเบียบการแสดงผล พร้อมส่งข้อมูลไปหน้าทัดไป
    // leading: SizedBox(
    //   width: 50,
    //   height: 50,
    //   child: Image.network(topics.ImageUrl),
    // ),
  ),
);
*/
class TopicCardPage extends StatefulWidget {
  final TopicDataModel topics;

  const TopicCardPage({Key? key, required this.topics}) : super(key: key);

  @override
  State<TopicCardPage> createState() => _TopicCardPageState();
}

class _TopicCardPageState extends State<TopicCardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          topicReadCount(widget.topics.topicId);
          Get.to(CommentPage(), arguments: widget.topics);
          //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>widget.topics(fruitDataModel: widget.topics,)));
        },
        title: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                buildImageProfile('${widget.topics.userInfoData?.profilePic}'),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Username : ${widget.topics.userInfoData?.userName}'),
                      Row(children: <Widget>[
                        Text('Expert : ${widget.topics.userInfoData?.expert}'),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: widget.topics.userInfoData?.verifyStatus == false
                                ? Icon(FontAwesomeIcons.square,
                                    color: Colors.black)
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Headline : ${widget.topics.topicHeadline}'),
                      Text('Group : ${widget.topics.topicGroup}'),
                      Text('${widget.topics.topicCaption}'),
                    ],
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
                  child: Text('${widget.topics.topicReadCount}'),
                ),
                Icon(FontAwesomeIcons.comment),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text('${widget.topics.topicCommentCount}'),
                ),
                IconButton(
                    onPressed: () {
                      //TODO: DONATE PAGE
                      donateSheet(
                          widget.topics.topicId,
                          widget.topics.topicHeadline,
                          widget.topics.userInfoData?.userInfoId,
                          widget.topics.userInfoData?.profilePic,
                          widget.topics.userInfoData?.userName);
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
                  child: Text('${widget.topics.topicDonateCount}'),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (widget.topics.likeStatus == 0) {
                          widget.topics.likeStatus = 1;
                          widget.topics.topicLikeCount =
                          (widget.topics.topicLikeCount! + 1);
                        } else {
                          widget.topics.likeStatus = 0;
                          widget.topics.topicLikeCount =
                          (widget.topics.topicLikeCount! - 1);
                        }
                        LikePushButton(
                            widget.topics.topicId,
                            widget.topics.likeStatus,
                            widget.topics.topicHeadline);
                      });
                    },
                    icon: widget.topics.likeStatus == 0
                        ? Icon(FontAwesomeIcons.heart, color: Colors.black)
                        : Icon(FontAwesomeIcons.heartCircleCheck,
                            color: Colors.red)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text('${widget.topics.topicLikeCount}'),
                ),
              ],
            )
          ],
        ),
        // TODO: ให้มันแสดงรูปและจัดระเบียบการแสดงผล พร้อมส่งข้อมูลไปหน้าทัดไป
        // leading: SizedBox(
        //   width: 50,
        //   height: 50,
        //   child: Image.network(widget.topics.ImageUrl),
        // ),
      ),
    );
  }
}
