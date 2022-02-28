import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:http/http.dart' as http;
import "dart:io";
import 'config/config.dart';

class LoginMenu extends StatefulWidget {
  final FacebookLogin plugin;

  const LoginMenu({Key? key, required this.plugin}) : super(key: key);

  @override
  _LoginMenuState createState() => _LoginMenuState();
}

class _LoginMenuState extends State<LoginMenu> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _passWord = TextEditingController();

  //fb login
  String? _sdkVersion;
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _email2;
  String? _imageUrl;
  String? _passWordFb;

  @override
  void initState() {
    super.initState();

    _getSdkVersion();
    _updateLoginInfo();
  }

  Future<void> LoginCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({'email': _email.text, 'password': _passWord.text});

    var url = Uri.parse('${Config.API_URL}/user/login');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });

    Map resMap = jsonDecode(response.body);

    if (resMap["message"] == null) {
      print('Response status: ${response.statusCode}\n\n');
      print('Response body data: ${resMap["data"]}\n\n');
    } else {
      print('Response body: ${response.body}\n\n');
      print('Response body: ${resMap["message"]}\n\n');
    }
  }

  Future<void> LoginCallApiFb() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({'email': _email2, 'password': _passWordFb});

    var url = Uri.parse('${Config.API_URL}/user/loginfb');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });

    Map resMap = jsonDecode(response.body);

    if (resMap["message"] == null) {
      print('Response status: ${response.statusCode}\n\n');
      print('Response body data: ${resMap["data"]}\n\n');
    } else {
      print('Response body: ${response.body}\n\n');
      print('Response body: ${resMap["message"]}\n\n');
    }
  }

  Future<void> _onPressedLogInButton() async {
    await widget.plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    await _updateLoginInfo();
    await LoginCallApiFb();
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
      _email2 = email;
      _imageUrl = imageUrl;
      _passWordFb = passWordFb;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LOGIN PAGE"),
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
                        return "plass enter Email";
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
                        return "plass enter PassWord";
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
                          LoginCallApi();
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
                      onPressed: () {},
                      child: Text('GOOGLE'),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          //primary: Colors.red, // foreground
                          ),
                      onPressed: _onPressedLogInButton,
                      child: Text('FACEBOOk'),
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
