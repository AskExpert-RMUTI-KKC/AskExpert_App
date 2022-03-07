import 'dart:convert';
import 'package:askexpertapp/register.dart';
import 'package:askexpertapp/registerInfo.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import "dart:io";
import 'config/config.dart';
import 'package:get/get.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);


class LoginMenu extends StatefulWidget {
  final plugin = FacebookLogin(debug: true);

  @override
  _LoginMenuState createState() => _LoginMenuState();
}

class _LoginMenuState extends State<LoginMenu> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _passWord = TextEditingController();

  //Fb login
  String? _sdkVersion;
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _emailFb;
  String? _imageUrl;
  String? _passWordFb;

  //G login
  GoogleSignInAccount? _currentUser;
  String? _Gmail;
  String? _passWordG; //ID

  @override
  void initState() {

    _googleSignIn.signInSilently();
    _getSdkVersion();

    super.initState();
  }

  Future<void> _HandleLogin(var response) async{

    //full json DATA model form LoginCallAPi() funcion

    Map resMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('\nResponse status: ${response.statusCode}');
      print('\nResponse message: ${resMap["message"]}');
      print('\nResponse body data: ${resMap["data"]}');

      //SAVE TOKEN
      String? getToken = await tokenStore.getToken();
      print("data SecureStorage : ${getToken}");
      if(resMap["message"] == "register"){
        Get.to(registerInfo());
      }
    } else {
      print('\nResponse message: ${resMap["message"]}');
    }
  }

  Future<void> _LoginCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({'email': _email.text, 'password': _passWord.text});

    var url = Uri.parse('${Config.API_URL}/user/login');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    await _HandleLogin(response);
  }

  Future<void> _LoginCallApiFb() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({'email': _emailFb, 'password': _passWordFb});

    var url = Uri.parse('${Config.API_URL}/user/loginfb');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    await _HandleLogin(response);
  }

  Future<void> _LoginCallApiG() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({'email': _Gmail, 'password': _passWordG});

    var url = Uri.parse('${Config.API_URL}/user/logingoogle');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    await _HandleLogin(response);
  }

  Future<void> _GsignIn() async {
    _googleSignIn.disconnect();
    try{
      await _googleSignIn.signIn();
    }catch (e){
      print('Error signing in $e');
    }
    // _Gmail = _googleSignIn.currentUser?.email;
    // _passWordG = _googleSignIn.currentUser?.id;
    setState(() {
      _Gmail = _googleSignIn.currentUser?.email;
      _passWordG = _googleSignIn.currentUser?.id;
    });

    print(_Gmail);
    print(_passWordG);
    _googleSignIn.disconnect();

    await _LoginCallApiG();
  }

  Future<void> _FBsignIn() async {
    await widget.plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    await _updateLoginInfo();
    await _LoginCallApiFb();
  }

  Future<void> _onPressedExpressLogInButton(BuildContext context) async {
    final res = await widget.plugin.expressLogin();
    if (res.status == FacebookLoginStatus.success) {
      await _updateLoginInfo();
    } else {
      await showDialog<Object>(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("Can't make express log in. Try regular log in."),
        ),
      );
    }
  }

  Future<void> _onPressedLogOutButton() async {
    await widget.plugin.logOut();
    await _updateLoginInfo();
  }

  Future<void> _getSdkVersion() async {
    final sdkVersion = await widget.plugin.sdkVersion;
    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  Future<void> _updateLoginInfo() async {
    final plugin = widget.plugin;
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;

    if (token != null) {
      profile = await plugin.getUserProfile();
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
      }
      imageUrl = await plugin.getProfileImageUrl(width: 100);
    }

    String passWordFb = profile?.toMap()["userId"];

    print("token : ${token}\n");
    print("profile : ${profile}\n");
    print("passWordFb : ${passWordFb}\n");
    print("email : ${email}\n");

    setState(() {
      _token = token;
      _profile = profile;
      _emailFb = email;
      _imageUrl = imageUrl;
      _passWordFb = passWordFb;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LOGIN"),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // TextFormField(
                  //   decoration: new InputDecoration(label: Text("UserName")),
                  // ),
                  TextFormField(
                    decoration: new InputDecoration(label: Text("Email")),
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "please enter Email";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: new InputDecoration(label: Text("PassWord")),
                    obscureText: true,
                    controller: _passWord,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "please enter PassWord";
                      } else {
                        return null;
                      }
                    },
                  ),
                  // TextFormField(
                  //   decoration: new InputDecoration(label: Text("re-PassWord")),
                  //   obscureText: true,
                  // ),
                  SizedBox(
                    width: 300,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          //primary: Colors.red, // foreground
                          ),
                      onPressed: () {
                        bool pass = _formKey.currentState!.validate();
                        if (pass) {
                          // TODO : pass
                          //_formKey.currentState!.reset();
                          _LoginCallApi();
                          print("${_email.text}");
                          print("${_passWord.text}");
                        }
                      },
                      child: Text('LOGIN'),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          //primary: Colors.red, // foreground
                          ),
                      onPressed: _GsignIn,
                      child: Text('GOOGLE'),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        //primary: Colors.red, // foreground
                      ),
                      onPressed: _FBsignIn,
                      child: Text('FACEBOOk'),
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        //primary: Colors.red, // foreground
                      ),
                      onPressed: (){Get.to(register());},
                      child: Text('REGISTER'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
// ElevatedButton(
//   style: ElevatedButton.styleFrom(
//     primary: Colors.red, // background
//     onPrimary: Colors.white, // foreground
//   ),
//   onPressed: () { },
//   child: Text('ElevatedButton with custom foreground/background'),
// ),
// OutlinedButton(
//
//   onPressed: () { },
//   child: Text('Looks like an OutlineButton'),
// )
