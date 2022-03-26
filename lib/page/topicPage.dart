import 'dart:convert';

import 'package:askexpertapp/config/config.dart';
import 'package:askexpertapp/dataModel/topicDataModel.dart';
import 'package:askexpertapp/page/commentPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;

class topicPage extends StatefulWidget {
  const topicPage({Key? key}) : super(key: key);

  @override
  _topicPageState createState() => _topicPageState();
}

class _topicPageState extends State<topicPage> {
  List<topicDataModel> topicAll = [];
  List<topicDataModel> topics = List.generate(
    0,
        (index) => topicDataModel(),
  );
  Future<void> topicCall() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    var url = Uri.parse('${Config.API_TOPIC_FINDALL}');
    var response = await http.post(url);
    Map resMap = jsonDecode(response.body);

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    setState(() {
      for(int i = 0; i < resMap["data"].length;i++){
        topics.add(topicDataModel.fromJson(resMap["data"][i]));
      }
      print('\nResponse topicAll: ${topics.length}');
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  @override
  void initState() {
    // TODO: implement initState
    topicCall();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TOPIC ALL'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('${topics[index].topicCaption}'),
              // TODO: ให้มันแสดงรูปและจัดระเบียบการแสดงผล พร้อมส่งข้อมูลไปหน้าทัดไป
              // leading: SizedBox(
              //   width: 50,
              //   height: 50,
              //   child: Image.network(topics[index].ImageUrl),
              // ),
              onTap: (){
                Get.to(commentPage(),arguments: topics[index]);
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>topics(fruitDataModel: topics[index],)));
              },
            ),
          );
        },
      ), // ListView.builder
    );
  }
}
