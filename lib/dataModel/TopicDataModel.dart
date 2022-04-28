class TopicDataModel {
  int? likeStatus;
  String? topicId;
  String? topicHeadline;
  String? topicCaption;
  String? topicUserId;
  int? topicLikeCount;
  int? topicCommentCount;
  int? topicReadCount;
  int? topicDonateCount;
  String? topicGroup;
  int? topicReportStatus;
  UserInfoData? userInfoData;

  TopicDataModel(
      {this.likeStatus,
        this.topicId,
        this.topicHeadline,
        this.topicCaption,
        this.topicUserId,
        this.topicLikeCount,
        this.topicCommentCount,
        this.topicReadCount,
        this.topicDonateCount,
        this.topicGroup,
        this.topicReportStatus,
        this.userInfoData});

  TopicDataModel.fromJson(Map<String, dynamic> json) {
    likeStatus = json['likeStatus'];
    topicId = json['topicId'];
    topicHeadline = json['topicHeadline'];
    topicCaption = json['topicCaption'];
    topicUserId = json['topicUserId'];
    topicLikeCount = json['topicLikeCount'];
    topicCommentCount = json['topicCommentCount'];
    topicReadCount = json['topicReadCount'];
    topicDonateCount = json['topicDonateCount'];
    topicGroup = json['topicGroup'];
    topicReportStatus = json['topicReportStatus'];
    userInfoData = json['userInfoData'] != null
        ? new UserInfoData.fromJson(json['userInfoData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['likeStatus'] = this.likeStatus;
    data['topicId'] = this.topicId;
    data['topicHeadline'] = this.topicHeadline;
    data['topicCaption'] = this.topicCaption;
    data['topicUserId'] = this.topicUserId;
    data['topicLikeCount'] = this.topicLikeCount;
    data['topicCommentCount'] = this.topicCommentCount;
    data['topicReadCount'] = this.topicReadCount;
    data['topicDonateCount'] = this.topicDonateCount;
    data['topicGroup'] = this.topicGroup;
    data['topicReportStatus'] = this.topicReportStatus;
    if (this.userInfoData != null) {
      data['userInfoData'] = this.userInfoData!.toJson();
    }
    return data;
  }
}

class UserInfoData {
  String? userInfoId;
  String? userName;
  String? firstName;
  String? lastName;
  String? profilePic;
  bool? verifyStatus;
  String? expert;
  String? userCaption;

  UserInfoData(
      {this.userInfoId,
        this.userName,
        this.firstName,
        this.lastName,
        this.profilePic,
        this.verifyStatus,
        this.expert,
        this.userCaption});

  UserInfoData.fromJson(Map<String, dynamic> json) {
    userInfoId = json['userInfoId'];
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profilePic = json['profilePic'];
    verifyStatus = json['verifyStatus'];
    expert = json['expert'];
    userCaption = json['userCaption'];
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
    return data;
  }
}