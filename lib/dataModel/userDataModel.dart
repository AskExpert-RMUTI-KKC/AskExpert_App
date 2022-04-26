class userDataModel {
  String? userInfoId;
  String? userName;
  String? firstName;
  String? lastName;
  double? token;
  String? profilePic;
  bool? verifyStatus;
  String? userCaption;
  String? expert;
  String? createdDateForOrder;
  int? createdDate;

  userDataModel(
      {this.userInfoId,
        this.userName,
        this.firstName,
        this.lastName,
        this.token,
        this.profilePic,
        this.verifyStatus,
        this.userCaption,
        this.expert,
        this.createdDateForOrder,
        this.createdDate});

  userDataModel.fromJson(Map<String, dynamic> json) {
    userInfoId = json['userInfoId'];
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    token = json['token'];
    profilePic = json['profilePic'];
    verifyStatus = json['verifyStatus'];
    userCaption = json['userCaption'];
    expert = json['expert'];
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
    data['expert'] = this.expert;
    data['createdDateForOrder'] = this.createdDateForOrder;
    data['createdDate'] = this.createdDate;
    return data;
  }
}