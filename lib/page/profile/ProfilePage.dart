import 'package:askexpertapp/page/register_login/Login.dart';
import 'package:askexpertapp/page/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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

import 'ProfileLogic.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserDataModel user = new UserDataModel();

  Future<void> UserCall() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.apiUserFindById}');
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
      user = UserDataModel.fromJson(resMap["data"]);
      print('pathProfilePic${resMap["data"]["profilePic"]}');
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  @override
  void initState() {
    UserCall();
    print('pathProfilePic${user.profilePic}');
    print("ProfilePageLoad");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: ListView(
        children: [
          if (user.profilePic != null)
            buildImageProfilePage('${user.profilePic}')
          else
            Placeholder(),
          // TODO MAKE FUNCTION FOR THIS CODE
          // TextButton(onPressed: (){
          //   logOut();
          //   Get.offAll(WelcomePage());
          // }, child: Text("LOGOUT")),
          //
          // TextButton(onPressed: (){
          //   DefaultCacheManager().emptyCache();
          //   print("clearCache");
          //   setState(() {
          //
          //   });
          // }, child: Text("clearCache")),
          Padding(
            padding: EdgeInsets.fromLTRB(
                0, 0, 0, 0), //child: buildImageProfilePage(),
          )
        ],
      ),
    );
  }
}
