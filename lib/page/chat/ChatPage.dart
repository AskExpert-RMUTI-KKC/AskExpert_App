import 'package:flutter/material.dart';

import '../../config/ConfigApp.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  //Call ContactList


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat',
            style: TextStyle(
              color: Color(ConfigApp.textColor),
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [],
          elevation: 0,
          centerTitle: false,
          backgroundColor: const Color(ConfigApp.appbarBg),
        ),
        backgroundColor: const Color(ConfigApp.appbarBg),
        body: Scaffold(

        ),
    );
  }
}
