import 'CommentDataModel.dart';
import 'UserDataModel.dart';

class ChatContactDataModel {
  String? chatContactId;
  String? chatTx;
  String? chatRx;
  bool? chatTxReadStatus;
  bool? chatRxReadStatus;
  int? chatTxUnReadCount;
  int? chatRxUnReadCount;
  int? createdDate;
  UserDataModel? userInfoData;

  ChatContactDataModel(
      {this.chatContactId,
        this.chatTx,
        this.chatRx,
        this.chatTxReadStatus,
        this.chatRxReadStatus,
        this.chatTxUnReadCount,
        this.chatRxUnReadCount,
        this.createdDate,
        this.userInfoData});

  ChatContactDataModel.fromJson(Map<String, dynamic> json) {
    chatContactId = json['chatContactId'];
    chatTx = json['chatTx'];
    chatRx = json['chatRx'];
    chatTxReadStatus = json['chatTxReadStatus'];
    chatRxReadStatus = json['chatRxReadStatus'];
    chatTxUnReadCount = json['chatTxUnReadCount'];
    chatRxUnReadCount = json['chatRxUnReadCount'];
    createdDate = json['createdDate'];
    userInfoData = json['userInfoDataRx'] != null
        ? new UserDataModel.fromJson(json['userInfoDataRx'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatContactId'] = this.chatContactId;
    data['chatTx'] = this.chatTx;
    data['chatRx'] = this.chatRx;
    data['chatTxReadStatus'] = this.chatTxReadStatus;
    data['chatRxReadStatus'] = this.chatRxReadStatus;
    data['chatTxUnReadCount'] = this.chatTxUnReadCount;
    data['chatRxUnReadCount'] = this.chatRxUnReadCount;
    data['createdDate'] = this.createdDate;
    if (this.userInfoData != null) {
      data['userInfoDataRx'] = this.userInfoData!.toJson();
    }
    return data;
  }
}