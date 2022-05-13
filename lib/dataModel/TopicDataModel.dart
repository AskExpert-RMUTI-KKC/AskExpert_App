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
  String? topicGroupName;
  int? topicReportStatus;
  List<TopicImg>? topicImg;
  UserInfoData? userInfoData;
  int? createdDate;

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
        this.topicGroupName,
        this.topicReportStatus,
        this.topicImg,
        this.userInfoData,
        this.createdDate
      });

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
    topicGroupName = json['topicGroupName'];
    topicReportStatus = json['topicReportStatus'];
    createdDate = json['createdDate'];
    if (json['topicImg'] != null) {
      topicImg = <TopicImg>[];
      json['topicImg'].forEach((v) {
        topicImg!.add(new TopicImg.fromJson(v));
      });
    }
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
    data['topicGroupName'] = this.topicGroupName;
    data['topicReportStatus'] = this.topicReportStatus;
    data['createdDate'] = this.createdDate;
    if (this.topicImg != null) {
      data['topicImg'] = this.topicImg!.map((v) => v.toJson()).toList();
    }
    if (this.userInfoData != null) {
      data['userInfoData'] = this.userInfoData!.toJson();
    }
    return data;
  }
}

class TopicImg {
  String? imgId;
  String? imgContentId;
  String? imgPath;
  String? imgName;
  String? createdDateForOrder;
  int? createdDate;

  TopicImg(
      {this.imgId,
        this.imgContentId,
        this.imgPath,
        this.imgName,
        this.createdDateForOrder,
        this.createdDate});

  TopicImg.fromJson(Map<String, dynamic> json) {
    imgId = json['imgId'];
    imgContentId = json['imgContentId'];
    imgPath = json['imgPath'];
    imgName = json['imgName'];
    createdDateForOrder = json['createdDateForOrder'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgId'] = this.imgId;
    data['imgContentId'] = this.imgContentId;
    data['imgPath'] = this.imgPath;
    data['imgName'] = this.imgName;
    data['createdDateForOrder'] = this.createdDateForOrder;
    data['createdDate'] = this.createdDate;
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