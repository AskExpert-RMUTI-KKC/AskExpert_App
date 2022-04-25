import 'dart:convert';
import 'dart:developer';

import 'package:askexpertapp/config/config.dart';
import 'package:askexpertapp/dataModel/commentDataModel.dart';
import 'package:askexpertapp/dataModel/topicDataModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;

class commentPage extends StatefulWidget {
  const commentPage({Key? key}) : super(key: key);

  @override
  _commentPageState createState() => _commentPageState();
}

class _commentPageState extends State<commentPage> {
  topicDataModel topic = new topicDataModel();
  List<commentDataModel> comments = List.generate(
    0,
    (index) => commentDataModel(),
  );

  Future<void> commentCall(String? topicId) async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    var url = Uri.parse('${ConfigApp.apiTopicTopicId}');
    var response = await http.post(url, body: topicId);
    Map resMap = jsonDecode(response.body);

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');

    setState(() {
      for(int i = 0; i < resMap["data"].length;i++){
        comments.add(commentDataModel.fromJson(resMap["data"][i]));
      }
      for(int i = 0; i < resMap["data"].length;i++){
        comments.add(commentDataModel.fromJson(resMap["data"][i]));
      }
      for(int i = 0; i < resMap["data"].length;i++){
        comments.add(commentDataModel.fromJson(resMap["data"][i]));
      }
      for(int i = 0; i < resMap["data"].length;i++){
        comments.add(commentDataModel.fromJson(resMap["data"][i]));
      }
      for(int i = 0; i < resMap["data"].length;i++){
        comments.add(commentDataModel.fromJson(resMap["data"][i]));
      }
      for(int i = 0; i < resMap["data"].length;i++){
        comments.add(commentDataModel.fromJson(resMap["data"][i]));
      }
      print('\nResponse topicAll: ${comments.length}');
    });

    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future<void> Refresh() async {
    setState(() {
      comments = [];
      commentCall(topic.topicId);
    });

    //TODO : https://www.youtube.com/watch?v=eENDlIgadr4&list=WL&index=8&ab_channel=JohannesMilke
  }

  @override
  void initState() {
    topic = Get.arguments;
    commentCall(topic.topicId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TOPIC-COMMENT"),
      ),
      //Text('${topic.topicCaption}\n ${topic.topicId}\n ${topic.topicGroup}\n ${topic.topicHeadline}\n ')
      body: RefreshIndicator(
        onRefresh: Refresh,
        child: Container(
          child: Column(
            children: <Widget>[
              Card(
                  child: Text(
                      '${topic.topicCaption}\n ${topic.topicId}\n ${topic.topicGroup}\n ${topic.topicHeadline}\n ')),
              Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text('${comments[index].commentCaption}'),
                        // TODO: ให้มันแสดงรูปและจัดระเบียบการแสดงผล พร้อมส่งข้อมูลไปหน้าทัดไป
                        // leading: SizedBox(
                        //   width: 50,
                        //   height: 50,
                        //   child: Image.network(topics[index].ImageUrl),
                        // ),
                        onTap: () {
                          //Get.to(commentPage(),arguments: comments[index]);
                          //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>topics(fruitDataModel: topics[index],)));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
