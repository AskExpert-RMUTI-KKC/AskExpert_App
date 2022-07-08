import 'CommentDataModel.dart';

class ChatMesDataModel {
  String? chatMesId;
  String? chatContactId;
  String? chatTx;
  String? chatMes;
  int? createdDate;
  UserInfoData? userInfoDataTx;

  ChatMesDataModel(
      {this.chatMesId,
        this.chatContactId,
        this.chatTx,
        this.chatMes,
        this.createdDate,
        this.userInfoDataTx});

  ChatMesDataModel.fromJson(Map<String, dynamic> json) {
    chatMesId = json['chatMesId'];
    chatContactId = json['chatContactId'];
    chatTx = json['chatTx'];
    chatMes = json['chatMes'];
    createdDate = json['createdDate'];
    userInfoDataTx = json['userInfoDataTx'] != null
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
    if (this.userInfoDataTx != null) {
      data['userInfoDataTx'] = this.userInfoDataTx!.toJson();
    }
    return data;
  }
}