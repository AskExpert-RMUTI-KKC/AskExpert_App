class UserDataModel {
  String? userInfoId;
  String? userName;
  String? firstName;
  String? lastName;
  double? token;
  String? profilePic;
  bool? verifyStatus;
  String? userCaption;
  String? expertGroupId;
  double? tokenCount;
  int? likeCount;
  String? createdDateForOrder;
  int? createdDate;
  ExpertGroupListData? expertGroupListData;
  VerifyData? verifyData;

  UserDataModel(
      {this.userInfoId,
        this.userName,
        this.firstName,
        this.lastName,
        this.token,
        this.profilePic,
        this.verifyStatus,
        this.userCaption,
        this.expertGroupId,
        this.tokenCount,
        this.likeCount,
        this.createdDateForOrder,
        this.createdDate,
        this.expertGroupListData,
        this.verifyData});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    userInfoId = json['userInfoId'];
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    token = json['token'];
    profilePic = json['profilePic'];
    verifyStatus = json['verifyStatus'];
    userCaption = json['userCaption'];
    expertGroupId = json['expertGroupId'];
    tokenCount = json['tokenCount'];
    likeCount = json['likeCount'];
    createdDateForOrder = json['createdDateForOrder'];
    createdDate = json['createdDate'];
    expertGroupListData = json['expertGroupListData'] != null
        ? new ExpertGroupListData.fromJson(json['expertGroupListData'])
        : null;
    verifyData = json['verifyData'] != null
        ? new VerifyData.fromJson(json['verifyData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userInfoId'] = this.userInfoId;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['token'] = this.token;
    data['profilePic'] = this.profilePic;
    data['verifyStatus'] = this.verifyStatus;
    data['userCaption'] = this.userCaption;
    data['expertGroupId'] = this.expertGroupId;
    data['tokenCount'] = this.tokenCount;
    data['likeCount'] = this.likeCount;
    data['createdDateForOrder'] = this.createdDateForOrder;
    data['createdDate'] = this.createdDate;
    if (this.expertGroupListData != null) {
      data['expertGroupListData'] = this.expertGroupListData!.toJson();
    }
    if (this.verifyData != null) {
      data['verifyData'] = this.verifyData!.toJson();
    }
    return data;
  }
}

class ExpertGroupListData {
  String? expertGroupId;
  String? expertPath;
  int? expertStatus;
  String? createdDateForOrder;
  int? createdDate;

  ExpertGroupListData(
      {this.expertGroupId,
        this.expertPath,
        this.expertStatus,
        this.createdDateForOrder,
        this.createdDate});

  ExpertGroupListData.fromJson(Map<String, dynamic> json) {
    expertGroupId = json['expertGroupId'];
    expertPath = json['expertPath'];
    expertStatus = json['expertStatus'];
    createdDateForOrder = json['createdDateForOrder'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expertGroupId'] = this.expertGroupId;
    data['expertPath'] = this.expertPath;
    data['expertStatus'] = this.expertStatus;
    data['createdDateForOrder'] = this.createdDateForOrder;
    data['createdDate'] = this.createdDate;
    return data;
  }
}

class VerifyData {
  String? verifyId;
  String? verifyFrom;
  String? verifyExpert;
  String? verifyPassOf;
  String? verifyStatus;
  String? createdDateForOrder;
  int? createdDate;

  VerifyData(
      {this.verifyId,
        this.verifyFrom,
        this.verifyExpert,
        this.verifyPassOf,
        this.verifyStatus,
        this.createdDateForOrder,
        this.createdDate});

  VerifyData.fromJson(Map<String, dynamic> json) {
    verifyId = json['verifyId'];
    verifyFrom = json['verifyFrom'];
    verifyExpert = json['verifyExpert'];
    verifyPassOf = json['verifyPassOf'];
    verifyStatus = json['verifyStatus'];
    createdDateForOrder = json['createdDateForOrder'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verifyId'] = this.verifyId;
    data['verifyFrom'] = this.verifyFrom;
    data['verifyExpert'] = this.verifyExpert;
    data['verifyPassOf'] = this.verifyPassOf;
    data['verifyStatus'] = this.verifyStatus;
    data['createdDateForOrder'] = this.createdDateForOrder;
    data['createdDate'] = this.createdDate;
    return data;
  }
}