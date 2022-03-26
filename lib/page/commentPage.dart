import 'dart:developer';

import 'package:askexpertapp/dataModel/topicDataModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class commentPage extends StatefulWidget {
  const commentPage({Key? key}) : super(key: key);

  @override
  _commentPageState createState() => _commentPageState();
}

class _commentPageState extends State<commentPage> {
  topicDataModel topic = new topicDataModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    topic = Get.arguments;
    print(topic.topicCaption);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
