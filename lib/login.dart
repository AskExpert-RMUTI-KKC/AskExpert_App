import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:http/http.dart' as http;
import "dart:io";
import 'config/config.dart';





class LoginMenu extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _passWord = TextEditingController();


  //fb login

  Future<void> LoginCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({'email': _email.text, 'password': _passWord.text});

    var url = Uri.parse('http://192.168.1.2:8080/user/login');
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
                      onPressed: () {},
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
