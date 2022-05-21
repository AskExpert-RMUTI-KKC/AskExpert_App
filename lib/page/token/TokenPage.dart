import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/TransactionDataModel.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/UserDataModel.dart';
import 'package:askexpertapp/page/profile/ProfileSettingMenu.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../topic/CommentPage.dart';

class TokenPage extends StatefulWidget {
  const TokenPage({Key? key}) : super(key: key);

  @override
  State<TokenPage> createState() => _TokenPageState();
}

class _TokenPageState extends State<TokenPage> {
  List<TransactionDataModel> transactionList = List.generate(
    0,
    (index) => TransactionDataModel(),
  );

  UserDataModel user = new UserDataModel();

  Future<void> TransactionCall() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.apiTransactionTransactionHistory}');
    print('\n URL :${url.toString()}');
    var response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_tokenJwt}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    setState(() {
      for (int i = 0; i < resMap["data"].length; i++) {
        transactionList.add(TransactionDataModel.fromJson(resMap["data"][i]));
      }
      print('\nResponse topicAll: ${transactionList.length}');
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  late Future getUser;

  Future<void> UserCall() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.apiUserFindById}');
    print('\n URL :${url.toString()}');
    var response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_tokenJwt}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    setState(() {
      user = UserDataModel.fromJson(resMap["data"]);
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future<String> awaitUserCall() async {
    await UserCall();
    return "1";
  }

  Future<bool> AwaitTransactionCall() async {
    await UserCall();
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    TransactionCall();
    getUser = awaitUserCall();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Transaction',
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
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.btc,size: 30,),
                                SizedBox(width: 10,),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Text(
                                    "${user.token} Point",
                                    style: TextStyle(fontSize: 26),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.black,
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                        color: Colors.black, width: 3),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                  ),
                                  onPressed: () {
                                    print('Pressed');
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.circlePlus),
                                        SizedBox(width: 10),
                                        Text("Deposit"),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.black,
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                        color: Colors.black, width: 3),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                  ),
                                  onPressed: () {
                                    print('Pressed');
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                            FontAwesomeIcons.moneyBillTransfer),
                                        SizedBox(width: 10),
                                        Text("Withdraw"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: transactionList.length,
                              itemBuilder: (context, index) => Container(
                                margin: EdgeInsets.fromLTRB(0, 4, 0  , 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black,width: 4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    if (transactionList[index].topicId != null)
                                      Get.to(CommentPage(),
                                          arguments:
                                              transactionList[index].topicId);
                                    else {}
                                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>topics(fruitDataModel: topics[index],)));
                                  },
                                  textColor: Colors.black,
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "TranID : ${transactionList[index].tranId}",
                                        maxLines: 1,
                                      ),
                                      Text(
                                        "Amount : ${transactionList[index].tranAmount}",
                                        maxLines: 1,
                                      ),
                                      Text(
                                        "TxId : ${transactionList[index].userInfoDataTx?.userName}",
                                        maxLines: 1,
                                      ),
                                      Text(
                                        "RxId : ${transactionList[index].userInfoDataRx?.userName}",
                                        maxLines: 1,
                                      ),
                                      if (transactionList[index].topicContent !=
                                          null)
                                        Text(
                                          "Topic : ${transactionList[index].topicContent}",
                                          maxLines: 1,
                                        ),
                                      if (transactionList[index]
                                              .commentContent !=
                                          null)
                                        Text(
                                          "Comment : ${transactionList[index].commentContent}",
                                          maxLines: 1,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Material(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
