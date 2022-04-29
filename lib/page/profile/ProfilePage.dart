import 'package:askexpertapp/page/register_login/Login.dart';
import 'package:askexpertapp/page/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> logOut() async{
    String yourToken = "${await TokenStore.getToken()}";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(yourToken);
    print("decodedToken : ${decodedToken["principal"]}");

    await TokenStore.setToken("");
    String? getToken = await TokenStore.getToken();
    print("data SecureStorage : ${getToken}");
  }

  @override
  void initState(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Column(
        children: [
          TextButton(onPressed: (){
            logOut();
            Get.offAll(WelcomePage());
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
