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
import 'package:jwt_decoder/jwt_decoder.dart';

Widget buildImageProfilePage(String index) => ClipRRect(
  // backgroundImage: CachedNetworkImageProvider(
  //   '${Config.imgProfile}$index',
  // ),
  borderRadius: BorderRadius.circular(100),
  child: CachedNetworkImage(
    imageUrl: '${ConfigApp.imgProfile}$index',
    width: 120,
    height: 120,
    //fit: BoxFit.cover,
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


Future<void> logOut() async {
  String yourToken = "${await TokenStore.getToken()}";
  Map<String, dynamic> decodedToken = JwtDecoder.decode(yourToken);
  print("decodedToken : ${decodedToken["principal"]}");

  await TokenStore.setToken("");
  String? getToken = await TokenStore.getToken();
  print("data SecureStorage : ${getToken}");
}


