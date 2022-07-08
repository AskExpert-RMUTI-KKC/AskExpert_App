import 'dart:convert';

import 'package:askexpertapp/dataModel/ChatContactDataModel.dart';
import 'package:askexpertapp/dataModel/ChatMesDataModel.dart';
import 'package:flutter/material.dart';
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

  List<ChatMesDataModel> chatMesList = List.generate(
    0,
        (index) => ChatMesDataModel(),
  );

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
      print('chatContactId var ${chatContactId}');
      print('chatContactDataModel var ${chatContactDataModel.toJson()}');
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }


  //LoadMessage


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
    return Scaffold();
  }
}
