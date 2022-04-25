import 'package:askexpertapp/page/register_login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {


  @override
  void initState() {
    // TODO: implement initState
    print("${tokenStore.getToken()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(onPressed: (){
            Get.offAll(LoginPage());
          }, child: Text("LOGOUT")),
          TextButton(onPressed: (){
            DefaultCacheManager().emptyCache();
            print("clearCache");
            setState(() {

            });
          }, child: Text("clearCache")),
        ],
      ),
    );
  }
}
