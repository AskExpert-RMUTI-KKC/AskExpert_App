import 'package:askexpertapp/page/navigationBar.dart';
import 'package:askexpertapp/page/register_login/login.dart';
import 'package:askexpertapp/page/topic/topicPage.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

void routes(String check) async {
  if (check == "token") {
    String? token = await TokenStore.getToken();
    if (token == null) {
      Get.to(LoginPage());
    } else {
      Get.off(NavigationBarPage());
    }
  }

  if (check == "welcomePage") {
    String? token = await TokenStore.getToken();
    if (token == null) {
      //Get.to(LoginPage());
    } else {
      //Get.off(NavigationBarPage());

    }
  }
}
