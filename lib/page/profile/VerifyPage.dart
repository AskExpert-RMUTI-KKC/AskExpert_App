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

import '../NavigationBar.dart';
import '../profile/ProfilePage.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  List<ExpertDataModel> expertList = [];
  String? expertSelected;
  late Future getExpertList;
  UserDataModel user = UserDataModel();
  final _formKey = GlobalKey<FormState>();
  File? image;

  Future<void> expertListCallApi() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();

    String? _tokenJwt = await TokenStore.getToken();
    _tokenJwt = "Bearer " + _tokenJwt!;
    print("_tokenJwt : ${_tokenJwt}");

    var url = Uri.parse('${ConfigApp.apiExpertFindAll}');
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
        expertList.add(ExpertDataModel.fromJson(resMap["data"][i]));
      }
    });
    // print('\nResponse body data: ${resMap["data"]}');
    // print('\nResponse body data: ${resMap["data"]}');
  }

  Future<void> sendVerifyData() async {
    Map<String, String> params = Map();
    //Map<String, String> data = Map();
    var body = jsonEncode({
      'expertGroupId': expertSelected,
    });
    String? _authen = await TokenStore.getToken();
    _authen = "Bearer " + _authen!;
    print("body : ${body}");
    print("_authen : ${_authen}");
    var url = Uri.parse('${ConfigApp.apiVerifyAdd}');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_authen}"
    });
    Map resMap = jsonDecode(utf8.decode(response.bodyBytes));

    print('\nResponse status: ${response.statusCode}');
    print('\nResponse message: ${resMap["message"]}');
    print('\nResponse body data: ${resMap["data"]}');
    if (response.statusCode == 200 && resMap["message"] == null) {
      uploadImgVerify(image,resMap["data"]["verifyId"].toString());

    }
    else{
      Get.snackbar(
        "Verify Report Status",
        '${resMap["message"]}',
        icon: Icon(FontAwesomeIcons.addressCard, color: Colors.black),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(ConfigApp.warningSnackBar),
        colorText: Color(ConfigApp.warningSnackBarText),
      );
    }
  }

  Future<void> uploadImgVerify(File? file,verifyId) async {
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
    var request = http.MultipartRequest('POST', Uri.parse('${ConfigApp.imgUploadVerify}'));
    request.headers.addAll({"Authorization": "${_authen}"});
    print('_authen ${request.headers.toString()}');
    print('_authen URL  ${request.url.toString()}');
    Uint8List data = await file!.readAsBytes();
    List<int> list = data.cast();
    request.fields['verifyId'] = verifyId;
    request.files.add(http.MultipartFile.fromBytes('file', list,filename: 'myFile.png'));
    //request.fields.addAll(params); !Add Body
    var response = await request.send();
    response.stream.bytesToString().asStream().listen((event) {
      print('photo ${response.statusCode}');
      if(response.statusCode == 200){
        Get.back();
        Get.back();

        Get.snackbar(
          "Verify Report Status",
          'Send Verify Data Success',
          icon: Icon(FontAwesomeIcons.addressCard, color: Colors.black),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent,
          colorText: Color(ConfigApp.textColor),
        );

      }
      //It's done...
    });
  }

  Future selectFile() async {
    final imageFile = await pickImageKyc(true);
    if(imageFile!=null){
      print('\nImage File :${imageFile.path}');
      setState(() {
        final imageTemp = File(imageFile!.path);
        this.image = imageTemp;
      });
    }
    else{return;}
  }

  static Future<File?> pickImageKyc(bool isGallery) async {
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

  @override
  void initState() {
    expertListCallApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify',
          style: TextStyle(
            color: Color(ConfigApp.textColor),
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [],
        elevation: 0,
        centerTitle: false,
        backgroundColor: const Color(ConfigApp.appbarBg),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: const Color(ConfigApp.appbarBg),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Select Expert',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                              color: Color(ConfigApp.buttonSecondary))),
                    ),
                    value: expertSelected,
                    items: expertList
                        .map((DataList) => DropdownMenuItem(
                              child: Text('${DataList.expertPath}'),
                              value: DataList.expertGroupId,
                            ))
                        .toList(),
                    onChanged: (item) => setState(() {
                      expertSelected = item;
                    }),
                    validator: (input) {
                      if (input == null) {
                        return 'plase select expert';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Image.asset('assets/images/kyc.png',),
                InkWell(
                  onTap: (){selectFile();},
                  child: image == null
                      ? Icon(
                          FontAwesomeIcons.addressCard,
                    size: 150,
                        )
                      : Image.file(
                          image!,
                          height: 256,
                          width: 256,
                        ),
                )
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ElevatedButton(
              onPressed: () {
                bool pass = _formKey.currentState!.validate();
                if (image == null) {
                  pass = false;
                  Get.snackbar(
                    "Verify Report Status",
                    'Please Upload Verify Image',
                    icon: Icon(FontAwesomeIcons.addressCard, color: Colors.black),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Color(ConfigApp.warningSnackBar),
                    colorText: Color(ConfigApp.warningSnackBarText),
                  );
                }

                if (pass) {
                  sendVerifyData();
                }
              },
              child: const Text(
                "Send Veridy Data",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(ConfigApp.buttonPrimary),
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 50),
                primary: Color(ConfigApp.buttonSecondary),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                //side: BorderSide(width: 1,color: Color(Config.textColor),)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
