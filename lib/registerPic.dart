import 'package:askexpertapp/page/topicPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class registerPicProgile extends StatefulWidget {
  const registerPicProgile({Key? key}) : super(key: key);

  @override
  _registerPicProgileState createState() => _registerPicProgileState();
}

class _registerPicProgileState extends State<registerPicProgile> {
  @override
  void initState() {
    // TODO: implement initState
    Get.off(topicPage());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
