import 'dart:convert';

import 'package:askexpertapp/dataModel/ChatContactDataModel.dart';
import 'package:askexpertapp/dataModel/ChatMesDataModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/storageToken.dart';
import 'dart:convert';

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

import '../profile/ProfilePage.dart';
import '../topic/TopicLogic.dart';

class ChatMesPage extends StatefulWidget {
  const ChatMesPage({Key? key}) : super(key: key);

  @override
  State<ChatMesPage> createState() => _ChatMesPageState();
}

class _ChatMesPageState extends State<ChatMesPage> {
  late UserDataModel user = new UserDataModel();
  late String userIdFormGetArguments;
  late Future getUser;

  late String chatContactId;
  late ChatContactDataModel chatContactDataModel = new ChatContactDataModel();
  late String chatWith = "chatWith";

  late Future getChatMes;
  List<ChatMesDataModel> chatMesList = List.generate(
    0,
    (index) => ChatMesDataModel(),
  );

  final _commentCaption = TextEditingController();

  //firstContact
  Future<void> firstContact() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var response;
    var url;

    url = Uri.parse('${ConfigApp.chatFirstContact}');
    print('\n URL :${url.toString()}');
    response = await http.post(url, body: userIdFormGetArguments, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_tokenJwt}"
    });

    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    setState(() {
      print('chatContactId ${resMap["data"]["chatContactId"]}');
      chatContactDataModel = ChatContactDataModel.fromJson(resMap["data"]);
      chatContactId = resMap["data"]["chatContactId"];
      chatWith = "@${chatContactDataModel.userInfoData?.userName}";
      print('chatContactId var ${chatContactId}');
      print('chatContactDataModel var ${chatContactDataModel.toJson()}');
      chatMesListCall(chatContactId);
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  //LoadMessage
  Future<void> chatMesListCall(chatContactId) async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.chatMesWithRx}');
    print('\n URL :${url.toString()}');
    var response = await http.post(url, body: chatContactId, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_tokenJwt}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));
    print('\nTopic Response status: ${response.statusCode}');
    print('\nTopic Response message: ${resMap["message"]}');
    print('\nTopic Response body data: ${resMap["data"]}');
    setState(() {
      chatMesList = [];
      for (int i = 0; i < resMap["data"].length; i++) {
        chatMesList.add(ChatMesDataModel.fromJson(resMap["data"][i]));
      }
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  //chat

  Future<void> sendMesApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({
      'chatMes': _commentCaption.text,
      'chatContactId': chatContactId,
    });
    String? _authen = await TokenStore.getToken();
    _authen = "Bearer " + _authen!;
    print("body : ${body}");
    print("_authen : ${_authen}");
    var url = Uri.parse('${ConfigApp.chatSendMes}');
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
      setState(() {
        chatMesList.add(ChatMesDataModel.fromJson(resMap["data"]));
      });
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
                sendMesApi();
                _commentCaption.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> Refresh() async {
    //comments = [];
    setState(() {
      // topicCall(topicId);
      // commentCall(topicId);
    });

    //TODO : https://www.youtube.com/watch?v=eENDlIgadr4&list=WL&index=8&ab_channel=JohannesMilke
  }

  @override
  void initState() {
    // TODO: implement initState
    if (Get.arguments.toString().length > 16) {
      print("${Get.arguments.toString()}");
      userIdFormGetArguments = Get.arguments;
      firstContact();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${chatWith}',
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
                            itemCount: chatMesList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onLongPress: () {},
                                  onTap: () {},
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                  "Test ${chatMesList[index].userInfoData?.userInfoId}");
                                              Get.to(ProfilePage(),
                                                  arguments: chatMesList[index]
                                                      .userInfoData
                                                      ?.userInfoId);
                                            },
                                            child: buildImageProfileDonateSheet(
                                                chatMesList[index]
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
                                                ' ${chatMesList[index].userInfoData?.userName}' ,style: TextStyle(fontSize: 16),),
                                              Row(children: <Widget>[
                                                chatMesList[index]
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
                                                        '${chatMesList[index].userInfoData?.expertGroupListData?.expertPath}',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white),
                                                      ),
                                                      if (chatMesList[
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

                                              Text(
                                                  ' ${DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(chatMesList[index].createdDate!))}'),
                                            ],

                                          ),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: Text(
                                                ' ${chatMesList[index].chatMes}',style: TextStyle(fontSize: 20),
                                              )),
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
