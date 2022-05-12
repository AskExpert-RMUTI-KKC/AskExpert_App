import 'package:askexpertapp/page/NavigationBar.dart';
import 'package:askexpertapp/page/topic/TopicPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class RegisterImgPage extends StatefulWidget {
  const RegisterImgPage({Key? key}) : super(key: key);

  @override
  _RegisterImgPageState createState() => _RegisterImgPageState();
}

class _RegisterImgPageState extends State<RegisterImgPage> {
  @override
  void initState() {

    Get.off(NavigationBarPage());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
