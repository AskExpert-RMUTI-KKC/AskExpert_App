
import 'package:askexpertapp/page/register_login/login.dart';
import 'package:askexpertapp/page/topicPage.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

void routes(String check) async{
  if(check == "token"){
    String? token = await tokenStore.getToken();
    if(token == null){
      Get.to(LoginMenu());
    }
    else{
      Get.off(topicPage());
    }
  }

  if(check == "welcomePage"){
    String? token = await tokenStore.getToken();
    if(token == null){
      //Get.to(LoginMenu());
    }
    else{

      //Get.off(topicPage());

    }
  }

}
