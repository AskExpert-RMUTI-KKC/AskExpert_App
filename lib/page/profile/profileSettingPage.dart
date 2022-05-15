import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/page/NavigationBar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../dataModel/ExpertDataModel.dart';
import '../../utils/UtilsImg.dart';
import '../WelcomePage.dart';
import 'dart:convert';
import 'dart:io';

import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/UserDataModel.dart';
import 'package:askexpertapp/page/profile/ProfileSettingMenu.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'ProfileLogic.dart';
import 'VerifyPage.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({Key? key}) : super(key: key);

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {


  List<ExpertDataModel> expertList = [];
  String? expertSelected;
  late Future getExpertList;
  UserDataModel user = UserDataModel();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Setting',
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
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {Get.to(VerifyPage());},
                  child: const Text(
                    "Verify",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(ConfigApp.buttonPrimary),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    primary: Color(ConfigApp.buttonSecondary),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    //side: BorderSide(width: 1,color: Color(Config.textColor),)
                  ),
                ),
              ),
              Text('VerifyStatus'),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(ProfileSettingMenu());
                  },
                  child: const Text(
                    "Setting Profile",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(ConfigApp.buttonPrimary),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    primary: Color(ConfigApp.buttonSecondary),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    //side: BorderSide(width: 1,color: Color(Config.textColor),)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ElevatedButton(
                  onPressed: () {
                    DefaultCacheManager().emptyCache();
                    print("clearCache");
                    setState(() {});
                  },
                  child: const Text(
                    "ClearCache",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(ConfigApp.buttonPrimary),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    primary: Color(ConfigApp.buttonSecondary),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    //side: BorderSide(width: 1,color: Color(Config.textColor),)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ElevatedButton(
                  onPressed: () {
                    logOut();
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(ConfigApp.buttonPrimary),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    primary: Color(ConfigApp.buttonSecondary),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    //side: BorderSide(width: 1,color: Color(Config.textColor),)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
