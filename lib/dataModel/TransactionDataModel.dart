class TransactionDataModel {
  String? tranId;
  String? tranTx;
  String? tranRx;
  int? tranAmount;
  String? tranContentId;
  String? tranStatus;
  String? createdDateForOrder;
  int? createdDate;
  UserInfoDataTx? userInfoDataTx;
  UserInfoDataTx? userInfoDataRx;
  String? topicContent;
  String? topicId;
  String? commentContent;
  String? commentId;
  String? commentData;

  TransactionDataModel(
      {this.tranId,
        this.tranTx,
        this.tranRx,
        this.tranAmount,
        this.tranContentId,
        this.tranStatus,
        this.createdDateForOrder,
        this.createdDate,
        this.userInfoDataTx,
        this.userInfoDataRx,
        this.topicContent,
        this.topicId,
        this.commentContent,
        this.commentId,
        this.commentData});

  TransactionDataModel.fromJson(Map<String, dynamic> json) {
    tranId = json['tranId'];
    tranTx = json['tranTx'];
    tranRx = json['tranRx'];
    tranAmount = json['tranAmount'];
    tranContentId = json['tranContentId'];
    tranStatus = json['tranStatus'];
    createdDateForOrder = json['createdDateForOrder'];
    createdDate = json['createdDate'];
    userInfoDataTx = json['userInfoDataTx'] != null
        ? new UserInfoDataTx.fromJson(json['userInfoDataTx'])
        : null;
    userInfoDataRx = json['userInfoDataRx'] != null
        ? new UserInfoDataTx.fromJson(json['userInfoDataRx'])
        : null;
    topicContent = json['topicContent'];
    topicId = json['topicId'];
    commentContent = json['commentContent'];
    commentId = json['commentId'];
    commentData = json['commentData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tranId'] = this.tranId;
    data['tranTx'] = this.tranTx;
    data['tranRx'] = this.tranRx;
    data['tranAmount'] = this.tranAmount;
    data['tranContentId'] = this.tranContentId;
    data['tranStatus'] = this.tranStatus;
    data['createdDateForOrder'] = this.createdDateForOrder;
    data['createdDate'] = this.createdDate;
    if (this.userInfoDataTx != null) {
      data['userInfoDataTx'] = this.userInfoDataTx!.toJson();
    }
    if (this.userInfoDataRx != null) {
      data['userInfoDataRx'] = this.userInfoDataRx!.toJson();
    }
    data['topicContent'] = this.topicContent;
    data['topicId'] = this.topicId;
    data['commentContent'] = this.commentContent;
    data['commentId'] = this.commentId;
    data['commentData'] = this.commentData;
    return data;
  }
}

class UserInfoDataTx {
  String? userInfoId;
  String? userName;
  String? firstName;
  String? lastName;
  String? profilePic;
  bool? verifyStatus;
  String? expert;
  String? userCaption;
  double? tokenCount;
  int? likeCount;

  UserInfoDataTx(
      {this.userInfoId,
        this.userName,
        this.firstName,
        this.lastName,
        this.profilePic,
        this.verifyStatus,
        this.expert,
        this.userCaption,
        this.tokenCount,
        this.likeCount});

  UserInfoDataTx.fromJson(Map<String, dynamic> json) {
    userInfoId = json['userInfoId'];
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profilePic = json['profilePic'];
    verifyStatus = json['verifyStatus'];
    expert = json['expert'];
    userCaption = json['userCaption'];
    tokenCount = json['tokenCount'];
    likeCount = json['likeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userInfoId'] = this.userInfoId;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['profilePic'] = this.profilePic;
    data['verifyStatus'] = this.verifyStatus;
    data['expert'] = this.expert;
    data['userCaption'] = this.userCaption;
    data['tokenCount'] = this.tokenCount;
    data['likeCount'] = this.likeCount;
    return data;
  }
}