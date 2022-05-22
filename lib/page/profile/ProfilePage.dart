import 'dart:convert';

import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/UserDataModel.dart';
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

import 'ProfileLogic.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserDataModel user = new UserDataModel();
  late String userIdFormGetArguments;

  late Future getUser;
  Future<void> UserCall() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var response;
    var url;
    if(userIdFormGetArguments == 'Id'){
      url = Uri.parse('${ConfigApp.apiUserFindById}');
      print('\n URL :${url.toString()}');
      response = await http.post(url, headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "${_tokenJwt}"
      });
    }else{
      url = Uri.parse('${ConfigApp.apiUserFindByUserId}');
      print('\n URL :${url.toString()}');
      response = await http.post(url,body: userIdFormGetArguments);
    }
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    setState(() {
      user = UserDataModel.fromJson(resMap["data"]);
      print('pathProfilePic${resMap["data"]["profilePic"]}');
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future<String> awaitUserCall() async {
    await UserCall();
    return "1";
  }

  @override
  void initState() {
    if(Get.arguments != null){
      if(Get.arguments.toString().length> 16){
        userIdFormGetArguments = Get.arguments;
      }
    }
    else
      {
        userIdFormGetArguments = 'Id';
      }
    getUser = awaitUserCall();
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Profile',
                style: TextStyle(
                  color: Color(ConfigApp.textColor),
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                userIdFormGetArguments == 'Id'
                ?IconButton(
                    onPressed: () {
                      Get.to(ProfileSetting(),arguments: user);
                    },
                    icon: Icon(
                      FontAwesomeIcons.gear,
                      color: Colors.black,
                    ))
                    :Container(),
              ],
              elevation: 0,
              centerTitle: false,
              backgroundColor: const Color(ConfigApp.appbarBg),
            ),
            backgroundColor: const Color(ConfigApp.appbarBg),
            body: ListView(
              children: <Widget>[
                if (user.profilePic != null)
                  Container(
                    child: buildImageProfilePage('${user.profilePic}'),
                  )
                else
                  Placeholder(),

                Column(
                  children: <Widget>[
                    Text('@${user.userName}'),
                    Text('${user.firstName} ${user.lastName}'),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          user.expertGroupListData != null
                              ?Container(
                            padding: EdgeInsets.fromLTRB(3, 2, 3, 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                        10.0) //                 <--- border radius here
                                    ),
                                color: Colors.black),
                            child: Row(
                              children: [
                                Text(
                                  '${user.expertGroupListData!.expertPath}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                if (user.verifyStatus ==
                                    true)
                                  Padding(
                                      padding:
                                      EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Icon(
                                          FontAwesomeIcons.circleCheck,
                                          color: Colors.lightBlueAccent)),
                              ],
                            ),
                          )
                              :Container()
                        ]),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.heartCircleCheck,
                      color: Colors.black,
                    ),
                    Text('${NumberFormat.compact().format(user.likeCount)}'),
                    Icon(
                      FontAwesomeIcons.btc,
                      color: Colors.black,
                    ),
                    Text('${NumberFormat.compact().format(user.tokenCount)}'),
                  ],
                ),

                Container(
                  child: Text("Bio"),
                ),
                Container(
                  child: Text("${user.userCaption}"),
                ),
                // TODO MAKE FUNCTION FOR THIS CODE
              ],
            ),
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
    );
  }
}
