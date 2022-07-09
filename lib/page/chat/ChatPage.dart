import 'dart:convert';

import 'package:askexpertapp/dataModel/ChatContactDataModel.dart';
import 'package:askexpertapp/page/profile/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/UserDataModel.dart';
import 'package:askexpertapp/page/chat/ChatMesPage.dart';
import 'package:askexpertapp/page/profile/ProfileSettingMenu.dart';
import 'package:askexpertapp/page/profile/profileSettingPage.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../config/ConfigApp.dart';
import '../../utils/storageToken.dart';
import '../topic/TopicLogic.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //Call ContactList
  List<ChatContactDataModel> chatContactDataList = List.generate(
    0,
    (index) => ChatContactDataModel(),
  );

  Future<void> chatContactListCall() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.chatMyContact}');
    print('\n URL :${url.toString()}');
    var response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_tokenJwt}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));
    print('\nTopic Response status: ${response.statusCode}');
    print('\nTopic Response message: ${resMap["message"]}');
    print('\nTopic Response body data: ${resMap["data"]}');
    setState(() {
      chatContactDataList = [];
      for (int i = 0; i < resMap["data"].length; i++) {
        chatContactDataList
            .add(ChatContactDataModel.fromJson(resMap["data"][i]));
      }
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future<void> Refresh() async {
    //comments = [];
    setState(() {
      // topicCall(topicId);
      // commentCall(topicId);
    });

    //TODO : https://www.youtube.com/watch?v=eENDlIgadr4&list=WL&index=8&ab_channel=JohannesMilke
  }

  late String chatContactId;
  late ChatContactDataModel chatContactDataModel = new ChatContactDataModel();
  late String chatWith = "chatWith";

  @override
  void initState() {
    chatContactListCall();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
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
        child: RefreshIndicator(
          onRefresh: Refresh,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                      child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: chatContactDataList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(ChatMesPage(),
                                        arguments: chatContactDataList[index]
                                            .chatContactId);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          height: 64,
                                          width: 64,
                                          padding: EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              print(
                                                  "Test ${chatContactDataList[index].userInfoData?.userInfoId}");
                                              Get.to(ProfilePage(),
                                                  arguments:
                                                      chatContactDataList[index]
                                                          .userInfoData
                                                          ?.userInfoId);
                                            },
                                            child: buildImageProfileDonateSheet(
                                                chatContactDataList[index]
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
                                                  ' ${chatContactDataList[index].userInfoData?.userName}' ,style: TextStyle(fontSize: 18),),
                                              Row(children: <Widget>[
                                                chatContactDataList[index]
                                                            .userInfoData
                                                            ?.expertGroupListData !=
                                                        null
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
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
                                                              '${chatContactDataList[index].userInfoData?.expertGroupListData?.expertPath}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            if (chatContactDataList[
                                                                        index]
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
                                                                      color: Colors
                                                                          .lightBlueAccent)),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),

                                              ]),
                                            ],
                                          ),

                                          //TODO something
                                          // Container(
                                          //     width:
                                          //     MediaQuery.of(context)
                                          //         .size
                                          //         .width *
                                          //         0.6,
                                          //     child: Text(
                                          //       '${chatContactDataList[index].chatContactId}',

                                          //     )),
                                        ],
                                      ),

                                      //TODO
                                      // Column(
                                      //   children: <Widget>[
                                      //     IconButton(
                                      //         onPressed: () {
                                      //           donateSheet(
                                      //               comments[index]
                                      //                   .commentId,
                                      //               comments[index]
                                      //                   .commentCaption,
                                      //               comments[index]
                                      //                   .userInfoData
                                      //                   ?.userInfoId,
                                      //               comments[index]
                                      //                   .userInfoData
                                      //                   ?.profilePic,
                                      //               comments[index]
                                      //                   .userInfoData
                                      //                   ?.userName);
                                      //         },
                                      //         icon: Icon(
                                      //             FontAwesomeIcons.btc)),
                                      //     Padding(
                                      //       padding: EdgeInsets.fromLTRB(
                                      //           0, 0, 0, 0),
                                      //       child: Text(
                                      //           '${NumberFormat.compact().format(comments[index].commentDonateCount)}'),
                                      //     ),
                                      //   ],
                                      // ),
                                      // Column(
                                      //   children: <Widget>[
                                      //     IconButton(
                                      //         onPressed: () {
                                      //           setState(() {
                                      //             if (comments[index]
                                      //                 .likeStatus ==
                                      //                 0) {
                                      //               comments[index]
                                      //                   .likeStatus = 1;
                                      //               comments[index]
                                      //                   .commentLikeCount =
                                      //               (comments[index]
                                      //                   .commentLikeCount! +
                                      //                   1);
                                      //             } else {
                                      //               comments[index]
                                      //                   .likeStatus = 0;
                                      //               comments[index]
                                      //                   .commentLikeCount =
                                      //               (comments[index]
                                      //                   .commentLikeCount! -
                                      //                   1);
                                      //             }
                                      //             LikePushButton(
                                      //                 comments[index]
                                      //                     .commentId,
                                      //                 comments[index]
                                      //                     .likeStatus,
                                      //                 comments[index]
                                      //                     .commentCaption);
                                      //           });
                                      //         },
                                      //         icon: comments[index]
                                      //             .likeStatus ==
                                      //             0
                                      //             ? Icon(
                                      //             FontAwesomeIcons
                                      //                 .heart,
                                      //             color: Colors.black)
                                      //             : Icon(
                                      //             FontAwesomeIcons
                                      //                 .heartCircleCheck,
                                      //             color: Colors.red)),
                                      //     Padding(
                                      //       padding:
                                      //       const EdgeInsets.fromLTRB(
                                      //           0, 0, 0, 0),
                                      //       child: Text(
                                      //           '${comments[index].commentLikeCount}'),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
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
