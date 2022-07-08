import 'CommentDataModel.dart';

class ChatMesDataModel {
  String? chatMesId;
  String? chatContactId;
  String? chatTx;
  String? chatMes;
  int? createdDate;
  UserInfoData? userInfoData;

  ChatMesDataModel(
      {this.chatMesId,
        this.chatContactId,
        this.chatTx,
        this.chatMes,
        this.createdDate,
        this.userInfoData});

  ChatMesDataModel.fromJson(Map<String, dynamic> json) {
    chatMesId = json['chatMesId'];
    chatContactId = json['chatContactId'];
    chatTx = json['chatTx'];
    chatMes = json['chatMes'];
    createdDate = json['createdDate'];
    userInfoData = json['userInfoDataTx'] != null
        ? new UserInfoData.fromJson(json['userInfoDataTx'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatMesId'] = this.chatMesId;
    data['chatContactId'] = this.chatContactId;
    data['chatTx'] = this.chatTx;
    data['chatMes'] = this.chatMes;
    data['createdDate'] = this.createdDate;
    if (this.userInfoData != null) {
      data['userInfoDataTx'] = this.userInfoData!.toJson();
    }
    return data;
  }
}