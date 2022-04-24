import 'package:askexpertapp/config/config.dart';
import 'package:askexpertapp/page/profile/profilePage.dart';
import 'package:askexpertapp/page/search/SearchPages.dart';
import 'package:askexpertapp/page/token/TokenPage.dart';
import 'package:askexpertapp/page/topic/topicPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'TopicAddPage.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);

  @override
  State<NavigationBarPage> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarPage> {
  int currentIndex = 0;

  final pages = [
    topicPage(),
    SearchPage(),
    TopicAddPage(),
    tokenPage(),
    profilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        
        backgroundColor: const Color(Config.appbarBg),
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey.withOpacity(0.7),
        selectedItemColor: Color(Config.textColor),
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
              FontAwesomeIcons.idBadge,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
