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
        this.createdDate});

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
    return data;
  }
}