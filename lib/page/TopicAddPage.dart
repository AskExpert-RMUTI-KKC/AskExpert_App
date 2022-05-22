import 'dart:convert';
import 'dart:typed_data';
import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/ExpertDataModel.dart';
import 'package:askexpertapp/page/NavigationBar.dart';
import 'package:askexpertapp/page/register_login/RegisterPic.dart';
import 'package:askexpertapp/page/topic/CommentPage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import "dart:io";
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/ExpertDataModel.dart';
import 'package:askexpertapp/dataModel/TopicDataModel.dart';
import 'package:askexpertapp/dataModel/UserDataModel.dart';
import 'package:askexpertapp/page/topic/CommentPage.dart';
import 'package:askexpertapp/page/topic/TopicCard.dart';
import 'package:askexpertapp/utils/storageToken.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../dataModel/TopicGroupDataModel.dart';

class TopicAddPage extends StatefulWidget {
  const TopicAddPage({Key? key}) : super(key: key);

  @override
  State<TopicAddPage> createState() => _TopicAddPageState();
}

class _TopicAddPageState extends State<TopicAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _topicHeadline = TextEditingController();
  final _topicCaption = TextEditingController();

  List<File> image = [];

  bool isSend = false;

  List<TopicGroupDataModel> topicGroupList = [];
  String? topicGroupSelected;
  late Future getTopicGroupList;

  Future<void> _createTopicCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({
      'topicHeadline': _topicHeadline.text,
      'topicCaption': _topicCaption.text,
      'topicGroupId': topicGroupSelected,
    });
    String? _authen = await TokenStore.getToken();
    _authen = "Bearer " + _authen!;
    print("body : ${body}");
    print("_authen : ${_authen}");
    var url = Uri.parse('${ConfigApp.apiTopicAdd}');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_authen}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    print('\n resMap["data"]["topicId"] : ${resMap["data"]["topicId"]}');
    if (response.statusCode == 200 && resMap["message"] == null) {
      String topicId = resMap["data"]["topicId"].toString();
      for (int i = 0; i < image.length; i++) {
        await sendImageTopic(image[i],topicId);
      }

      print('\n\n\n${resMap["data"]["topicId"]}\n\n\n\n\n');
      // Get.offAll(NavigationBarPage(),arguments: '0');
      Get.offAll(NavigationBarPage());
      Get.offAll(NavigationBarPage());

      Get.to(CommentPage(), arguments: topicId);
    } else {
      Get.snackbar(
        "Register Report Status",
        '${resMap["message"]}',
        icon: Icon(FontAwesomeIcons.person, color: Colors.black),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(ConfigApp.warningSnackBar),
        colorText: Color(ConfigApp.warningSnackBarText),
      );
    }
  }

  Future sendImageTopic(File imageTopic,String topicId) async{

    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    // var body = jsonEncode({
    //   'firstName': _firstName.text,
    //   'lastName': _lastName.text,
    //   'userName': _userName.text,
    //   'userCaption': _userCaption.text,
    //   'expertGroupId': expertSelected,
    // });

    String? _authen = await TokenStore.getToken();
    _authen = "Bearer " + _authen!;
    var headers = {
      // "Accept": "application/json",
      // "content-type": "application/json",
      "Authorization": "${_authen}"
    };

    //print("body : ${body}");
    print("_authen : ${_authen}");
    var request = http.MultipartRequest('POST', Uri.parse('${ConfigApp.imgUploadTopic}'));
    request.headers.addAll({"Authorization": "${_authen}"});
    print('_authen ${request.headers.toString()}');
    print('_authen URL  ${request.url.toString()}');
    Uint8List data = await imageTopic!.readAsBytes();
    List<int> list = data.cast();
    request.fields['topicId'] = topicId;
    request.files.add(http.MultipartFile.fromBytes('file', list,filename: 'myFile.png'));
    //request.fields.addAll(params); !Add Body
    var response = await request.send();
    response.stream.bytesToString().asStream().listen((event) {
      print('photo ${response.statusCode}');
      if(response.statusCode == 200){

      }
      //It's done...
    });

  }

  Future<void> topicGroupListCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.apiTopicGroupListFindAll}');
    print('\n URL :${url.toString()}');
    var response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    setState(() {
      for (int i = 0; i < resMap["data"].length; i++) {
        topicGroupList.add(TopicGroupDataModel.fromJson(resMap["data"][i]));
      }
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future<void> addTopicImage() async {
    selectFile();
  }

  Future selectFile() async {
    final imageFile = await pickTopicImage(true);
    if (imageFile != null) {
      print('\nImage File :${imageFile.path}');
      setState(() {
        final imageTemp = File(imageFile!.path);
        this.image.add(imageTemp);
      });
    } else {
      return;
    }
  }

  static Future<File?> pickTopicImage(bool isGallery) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) return null;

    CroppedFile? _croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.original,
      ],
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
    );
    return File(_croppedFile!.path);
  }

  Future<void> removeTopicImage(File imageRemove) async {
    setState(() {
      image.remove(imageRemove);
    });
  }

  @override
  void initState() {
    topicGroupListCallApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "CreateTopic",
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
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                                child: TextFormField(
                                  maxLength: 64,
                                  decoration: const InputDecoration(
                                    label: Text("topicHeadline"),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide(
                                            color: Color(
                                                ConfigApp.buttonSecondary))),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _topicHeadline,
                                  validator: (input) {
                                    if (input!.isEmpty) {
                                      return "please enter topicHeadline";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                                child: TextFormField(
                                  maxLength: 512,
                                  maxLines: 5,
                                  decoration: const InputDecoration(
                                    label: Text("topicCaption"),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide(
                                            color: Color(
                                                ConfigApp.buttonSecondary))),
                                  ),
                                  controller: _topicCaption,
                                  validator: (input) {
                                    if (input!.isEmpty) {
                                      return "please enter topicCaption";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('TopicGroup '),
                              SizedBox(
                                height: 100,
                                width: 200,
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide(
                                            color: Color(
                                                ConfigApp.buttonSecondary))),
                                  ),
                                  value: topicGroupSelected,
                                  items: topicGroupList
                                      .map((DataList) => DropdownMenuItem(
                                            child: Text(
                                                '${DataList.topicGroupPath}'),
                                            value: DataList.topicGroupId,
                                          ))
                                      .toList(),
                                  onChanged: (item) => setState(() {
                                    topicGroupSelected = item;
                                  }),
                                  validator: (input) {
                                    if (input == null) {
                                      return "please enter Expert";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          image.length == 0
                              ? Container()
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: image.length,
                                  itemBuilder: (context,
                                          index) => /*TopicCardPage(topics: topics[index])*/ Container(
                                        height: 300,
                                        alignment: Alignment.center,
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional.topEnd,
                                          children: <Widget>[
                                            Container(
                                              child: Image.asset(
                                                  '${image[index].path}'),
                                              height: 256,
                                            ),
                                            InkWell(
                                              child: Container(
                                                  margin: EdgeInsets.all(8),
                                                  child: Icon(
                                                    FontAwesomeIcons
                                                        .circleMinus,
                                                    color: Colors.white,
                                                  )),
                                              onTap: () {
                                                removeTopicImage(image[index]);
                                              },
                                            ),
                                          ],
                                        ),
                                      )),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              width: 128,
                              height: 128,
                              child: Image.asset('assets/images/addImage.png'),
                            ),
                            onTap: () {
                              addTopicImage();
                            },
                          )
                        ],
                      ),
                    )),
                    isSend
                        ? Container(
                            height: 10,
                            child: LinearProgressIndicator(
                              color: Colors.greenAccent,
                              backgroundColor: Colors.black,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(300, 50),
                                primary: Color(ConfigApp.buttonSecondary),
                                elevation: 5,
                                shape: shape,
                                //side: BorderSide(width: 1,color: Color(Config.textColor),)
                              ),
                              onPressed: () {
                                bool pass = _formKey.currentState!.validate();
                                if (pass) {
                                  //_formKey.currentState!.reset();
                                  _createTopicCallApi();
                                  setState(() {
                                    isSend = true;
                                  });
                                  print(
                                      "topicHeadline : ${_topicHeadline.text}");
                                  print("topicCaption : ${_topicCaption.text}");
                                }
                              },
                              child: Text(
                                'Create Topic',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(ConfigApp.buttonPrimary),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
