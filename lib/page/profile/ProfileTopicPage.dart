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

class ProfileTopicPage extends StatefulWidget {
  const ProfileTopicPage({Key? key}) : super(key: key);

  @override
  State<ProfileTopicPage> createState() => _ProfileTopicPageState();
}

class _ProfileTopicPageState extends State<ProfileTopicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
