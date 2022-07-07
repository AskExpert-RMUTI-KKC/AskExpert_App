import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/page/profile/ProfilePage.dart';
import 'package:askexpertapp/page/search/SearchPages.dart';
import 'package:askexpertapp/page/token/TokenPage.dart';
import 'package:askexpertapp/page/topic/TopicPage.dart';
import 'package:askexpertapp/utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:convert';
import 'TopicAddPage.dart';
import 'chat/ChatPage.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);

  @override
  State<NavigationBarPage> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarPage> {
  int currentIndex = 0;

  final pages = [
    TopicPage(),
    SearchPage(),
    TopicAddPage(),
    TokenPage(),
    ChatPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    print('type ${Get.arguments.runtimeType}');
    if(Get.arguments != null && Get.arguments.toString().length< 2){
      setState(() {
        currentIndex = int.parse(Get.arguments);
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex]
      // IndexedStack(
      //   index: currentIndex,
      //   children: pages,
      // )
      ,
      bottomNavigationBar: BottomNavigationBar(

        backgroundColor: const Color(ConfigApp.appbarBg),
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey.withOpacity(0.7),
        selectedItemColor: Color(ConfigApp.textColor),
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.topic,
            ),
            label: "Topic",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_add,
            ),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.btc,
            ),
            label: "Token",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.message,
            ),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.idBadge,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
