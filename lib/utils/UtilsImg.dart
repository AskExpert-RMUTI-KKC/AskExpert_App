import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:askexpertapp/config/ConfigApp.dart';
import 'package:askexpertapp/dataModel/CommentDataModel.dart';
import 'package:askexpertapp/dataModel/TopicDataModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import '../../utils/storageToken.dart';
import 'package:intl/intl.dart';

class UtilsImage {
  static Future<File?> pickImageProfile(bool isGallery) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) return null;

    CroppedFile? _croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile!.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1,),
      aspectRatioPresets: [CropAspectRatioPreset.square,],
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      maxWidth: 256,
      maxHeight: 256,
    );
    return File(_croppedFile!.path);
  }

  static Future<File?> cropImageSquare(File file) async {
    CroppedFile? _croppedFile = await ImageCropper().cropImage(
      sourcePath: file!.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1,),
      aspectRatioPresets: [CropAspectRatioPreset.square,],
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      maxWidth: 256,
      maxHeight: 256,
    );
    return File(_croppedFile!.path);
  }

  Future<void> uploadImgProfile(File? file) async {
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
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "${_authen}"
    };

    //print("body : ${body}");
    print("_authen : ${_authen}");
    var request = http.MultipartRequest('POST', Uri.parse('${ConfigApp.imgUploadProfile}}'));
    request.headers.addAll(headers);
    Uint8List data = await file!.readAsBytes();
    List<int> list = data.cast();
    request.files.add(http.MultipartFile.fromBytes('file', list,filename: 'myFile.png'));
    var response = await request.send();
    response.stream.bytesToString().asStream().listen((event) {
      var parsedJson = json.decode(event);
      print(parsedJson);
      print('photo ${response.statusCode}');
      //It's done...
    });
  }
    // var response = await http.post(url, body: body, headers: {
    //   "Accept": "application/json",
    //   "content-type": "application/json",
    //   "Authorization": "${_authen}"
    // });
}